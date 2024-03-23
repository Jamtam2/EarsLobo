class InquiriesController < ApplicationController
  def create
    @inquiry = Inquiry.new(inquiry_params)

    if @inquiry.save
      InquiryMailer.inquiry_email(@inquiry).deliver_later
      InquiryMailer.confirmation_email(@inquiry).deliver_later
      flash[:notice] = 'Inquiry sent! We will respond within 24-48 hours.'
      redirect_to home_path 
    else
      flash.now[:alert] = 'Failed to send inquiry: ' + @inquiry.errors.full_messages.to_sentence
      render 'pages/about'
    end
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(:email, :company, :purpose, :inquiry_type)
    end
end
