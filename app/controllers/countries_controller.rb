class CountriesController < ApplicationController
  before_action :authenticate_user!

  # Get all the records 
  def index
    @countries = Country.order(name: :asc).all
    
    respond_to do |format|
      format.html
      format.json { render json: @countries }
    end
  end

end
