class TestsController < ApplicationController



    def edit
      @client = Client.find(params[:client_id])
      @test = Test.find(params[:id])
      render :edit
    end
    

    def update
      @client = Client.find(params[:client_id])
      @test = @client.tests.find(params[:id])
      @test.assign_attributes(test_params)
    
      if @test.save
        redirect_to edit_client_path(@client)
      else
        render 'edit'
      end
    end

  




def create
    @client = Client.find(params[:client_id])
    @test = @client.tests.build(test_params)
    @test.user = current_user
    @test.client = @client

    if @test.save

      redirect_to edit_client_path(@client)
    else
      render 'new'
    end
  end


  
    private
  
    def test_params
      params.require(:test).permit(:label, :notes, :client_name, :test_type, :left_score, :right_score, :ear_advantage, :ear_advantage_score, :scan, :authenticity_token)
    end
      
  end
  