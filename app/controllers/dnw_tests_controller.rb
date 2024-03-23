class DnwTestsController < ApplicationController

    def new_dnw_list1
        @client = Client.find(params[:client_id])
        @dnw_test = @client.dnw_tests.build
        @dob = @client.date_of_birth
    end
  
    def new_dnw_list2
        @client = Client.find(params[:client_id])
        @dnw_test = @client.dnw_tests.build
        @dob = @client.date_of_birth
    end
  
    def new_dnw_list3
        @client = Client.find(params[:client_id])
        @dnw_test = @client.dnw_tests.build
        @dob = @client.date_of_birth
    end
  
    def new_dnw_list4
        @client = Client.find(params[:client_id])
        @dnw_test = @client.dnw_tests.build
        @dob = @client.date_of_birth
    end

    def index
        @dnw_tests = Dnw_Test.all
        render :index
    end


    def show
      @client = Client.find(params[:client_id])
      @dnw_test = @client.dnw_tests.find(params[:id])

    end


    def edit
        @client = Client.find(params[:client_id])
        @dnw_test = Dnw_Test.find(params[:id])
        render :edit
    end
      
  
      def update
        @client = Client.find(params[:client_id])
        @dnw_test = @client.dnw_tests.find(params[:id])
        @dnw_test.assign_attributes(dnw_test_params)
      
        if @dnw_test.save
          redirect_to edit_client_path(@client)
        else
          render 'edit'
        end
      end
  
    
  
  
  
  
  def create
      @client = Client.find(params[:client_id])
      @dnw_test = @client.dnw_tests.build(dnw_test_params)
      @dnw_test.user = current_user
      @dnw_test.client = @client
  
      if @dnw_test.save
  
        redirect_to edit_client_path(@client)
      else
        render 'new'
      end
    end
  
    def apply_discount
      @client = Client.find(params[:client_id])
      @dnw_test = DnwTest.find(params[:id])
      discount = Discount.find_by(code: params[:discount_code])
  
      if discount
        new_price = @dnw_test.price * (1 - discount.percentage_off / 100.0)
        @dnw_test.update(price:  new_price)
        redirect_to edit_client_path(@client)
        puts "------------------------------------------------"
        puts "TEST STUFF #{@dnw_test.inspect}"
        puts "------------------------------------------------"
        flash[:notice] = "Discount applied. New price: #{new_price}"
        
      else
        puts "------------------------------------------------"
        puts "IT DID NOT WORK STUFF #{@dnw_test.inspect}"
        puts "------------------------------------------------"
        redirect_to edit_client_path(@client)
        flash[:alert] = "Invalid discount code."
      end
    end

    
      private
    
      def dnw_test_params
        params.require(:dnw_test).permit(:label, :notes, :client_name, :test_type, :left_score, :right_score, :ear_advantage, :ear_advantage_score, :interpretation, :scan, :authenticity_token)
      end
    
end
