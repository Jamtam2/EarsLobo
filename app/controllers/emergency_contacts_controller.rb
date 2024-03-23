class EmergencyContactsController < ApplicationController
  def new
    @client = Client.find(params[:client_id])
    @emergency_contact = EmergencyContact.new
  end

  def create
    @client = Client.find(params[:client_id])
    @emergency_contact = @client.emergency_contacts.build(emergency_contact_params)

    if @emergency_contact.save
      redirect_to edit_client_path(@client), notice: "Emergency Contact created successfully."
    else
      flash.now[:error] = "Emergency Contact creation failed"
      render :new
    end
  end

  def edit
    @client = Client.find(params[:client_id])
    @emergency_contact = @client.emergency_contacts.find(params[:id])
  end

  def update
    @client = Client.find(params[:client_id])
    @emergency_contact = @client.emergency_contacts.find(params[:id])

    if @emergency_contact.update(emergency_contact_params)
      redirect_to edit_client_path(@client), notice: "Emergency Contact updated successfully."
    else
      flash.now[:error] = "Emergency Contact update failed"
      render :edit
    end
  end

  def destroy
    @client = Client.find(params[:client_id])
    @emergency_contact = @client.emergency_contacts.find(params[:id])
    @emergency_contact.destroy
    redirect_to edit_client_path(@client), notice: "Emergency contact successfully deleted."
  end

  private

  def emergency_contact_params
    params.require(:emergency_contact).permit(:first_name, :last_name, :phone_number, :address, :email, :state, :city)
  end
end
