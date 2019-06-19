class EventTypesController < ApplicationController
  #before_action :authenticate_user!

  # Get all the records 
  def index
    @event_types = EventType.includes(:tracking_milestone).order(name: :asc).all
    
    respond_to do |format|
      format.html
      format.json { render json: @event_types }
    end
  end

end
