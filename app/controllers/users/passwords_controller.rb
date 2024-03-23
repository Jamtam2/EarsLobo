# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    super
  end

  

  def create
    Rails.logger.info("DEBUG: USER TRIGGERED THIS")

    self.resource = resource_class.find_by_email(resource_params[:email])
  
    if resource
      resource.email_2fa_code = SecureRandom.hex(4)
      resource.email_2fa_code_sent_at = Time.current
      Rails.logger.info("DEBUG: THIS IS THE CODE #{resource.email_2fa_code}")
      Rails.logger.info("DEBUG: THIS IS THE TIME #{resource.email_2fa_code_sent_at}")
  
      # Save the user after setting the 2FA code and timestamp
      if resource.save
        UserMailer.send_2fa_code(resource, resource.email_2fa_code).deliver_later
        redirect_to new_verify_2fa_code_path, notice: '2FA code sent to your email. Please enter the code to continue resetting your password.'
      else
        # Handle save error
        respond_with(resource, alert: 'An error occurred while sending the 2FA code.')
      end
    else
      # Handle case where email is not found
      respond_with(resource, alert: 'Email not found.')
    end
  end
  

  # PUT /resource/password
  def update
    super
  end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
  def verify_2fa_code
    user = User.find_by_email_2fa_code(params[:email_2fa_code])
    Rails.logger.info("DEBUG: THIS IS THE USER IN VERIFY_2FA #{user}")

  
    if user && user.email_2fa_code_sent_at > 10.minutes.ago
      # Generate reset password token
      Rails.logger.info("DEBUG: GOT IN HERE #{user}")

      raw, hashed = Devise.token_generator.generate(User, :reset_password_token)
      user.update(
        reset_password_token: hashed,
        reset_password_sent_at: Time.now.utc
      )
  
      # Redirect to the password reset edit page with the raw token
      redirect_to edit_user_password_path(reset_password_token: raw)
    elsif user
      # Handle expired code
      redirect_to new_user_password_path, notice: 'Your code has expired, please try again.'
    else
      # Handle invalid code
      redirect_to new_user_password_path, alert: 'Invalid code, please try again.'
    end
  end
    

  # def verify_2fa_code
  #   user = User.find_by(email_2fa_code: params[:email_2fa_code])

  #   if user && user.email_2fa_code_sent_at > 10.minutes.ago
  #     # Code is valid and not expired, redirect to password reset edit page
  #     redirect_to edit_user_password_path(reset_password_token: user.reset_password_token)
  #   elsif user
  #     # Code is expired
  #     redirect_to new_user_password, notice: 'Your code has expired, please try again.'

  #   end
  # end
end
