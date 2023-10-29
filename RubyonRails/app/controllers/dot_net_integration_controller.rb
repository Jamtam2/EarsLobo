class DotNetIntegrationController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    # Handle data received.
    data = params[:data]
    # Save to database to process
    render json: { status: 'success' }
  end
end
