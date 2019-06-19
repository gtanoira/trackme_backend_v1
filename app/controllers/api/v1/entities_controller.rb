class EntitiesController < ApplicationController


  # Import Entities data from a Excel file
  def import
    Entity.import(params[:file])
    redirect_to entities_path, notice: 'Entities imported'
  end

  # Get all the records 
  def index
    if params[:type] != nil then
      @entities = Entity.includes(:country).where(entity_type: params[:type].upcase).order(name: :asc).all
    else
      @entities = Entity.includes(:country).order(name: :asc).all
    end
    
    respond_to do |format|
      format.html
      format.json { render json: @entities }
    end
  end


  # ******************************************************************************
  # Get a Customer Order by id
  # 
  # URL: /api/entities/[:id].json
  # Method: GET
  # URL params: 
  #   id: entity ID.
  # Response: 
  #   Content-type: application/json
  #   body: (JSON) => entity data
  # 
  def show
    rec_id = params[:id].to_i
    begin
      print '*** PASO 1'
      o = Entity.find(rec_id)
      @rec = {  
          id: o.id,
          name: o.name,
          address1: o.address1,
          address2: o.address2,
          city: o.city,
          zipcode: o.zipcode,
          state: o.state,
          alias: o.alias,
          entityType: o.entity_type,
          countryId: o.country_id,
          companyId: o.company_id
      }
    rescue ActiveRecord::RecordNotFound
      print '*** FALLO'
      @rec = {}
    end

    respond_to do |format|
      format.json { render json: @rec }
    end
  end

  # Ask to import Entities data from a Excel File
  def utilities
  end

end
