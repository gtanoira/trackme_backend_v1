class CompaniesController < ApplicationController
  before_action :authenticate_user!

  # Get all the records 
  def index
    @companies = Company.all
    
    respond_to do |format|
      format.html
      format.json { render json: @companies }
    end  end

end
