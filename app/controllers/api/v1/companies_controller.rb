module Api
  module V1

    class CompaniesController < Api::V1::ApplicationController
      before_action :authenticate_user!

      # Get all the records 
      def index
        @companies = Company.all
        
        respond_to do |format|
          format.html
          format.json { render json: @companies }
        end  end

    end
  end
end