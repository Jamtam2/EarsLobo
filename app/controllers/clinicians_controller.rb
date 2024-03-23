class CliniciansController < ApplicationController
    def new
        @clinician = Clinician.new
      end
    
    def create
        @clinician = Clinician.new(clinician_params)
        if @clinician.save
            flash[:success] = "Client successfully added!"
            redirect_to clinicians_path, notice: "Client created successfully."
          else
            flash.now[:error] = "Client creation failed"
            render :new
          end
    end

    def search
      if params[:search].blank?
        @clients = Client.all
      else
        @clients = Client.where("first_name ILIKE ? OR last_name ILIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
      end
    end
    
    def index
        @clinicians = Clinician.all
    end

end
