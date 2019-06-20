module Api
  module V1

    class CustomerOrderEventsController < Api::V1::ApplicationController
      skip_before_action :verify_authenticity_token

      # ******************************************************************************
      # Add a new event to a customer order
      #
      # URL: /api/customer_orders/:customer_order_id/customer_order_events
      # HTTP method: POST
      # Query params:  none
      # Request Body: (JSON) customer order data
      #
      def create
        begin
          puts "Cookie: #{request.headers['Cookie']}"
          customer_order_event = CustomerOrderEvent.new
          customer_order_event.event_type_id  = params['eventTypeId']
          customer_order_event.user_id        = current_user.id
          customer_order_event.order_id       = params['orderId']
          customer_order_event.event_datetime = params['eventDatetime']
          customer_order_event.event_scope    = params['event_scope']
          customer_order_event.observations   = params['observations']
          customer_order_event.save!

          respond_to do |format|
            format.json { render json: {message: 'Event saved.'} }
          end

        rescue => e
          puts "Error #{e.class}: #{e.message}"
          puts "ERROR BACKTRACE:"
          puts e.backtrace
          respond_to do |format|
            format.json { render json: {message: 'Error saving the event to the order',
                                        extraMsg: e.message} }
          end
        end
      end


      # ******************************************************************************
      # Get all the Events of a Order
      # 
      # URL: /api/customer_orders/:id/customer_order_events.json
      # HTTP method: GET
      # Query params:  
      #    :id (int): order ID 
      # Request Body: (Array of JSONs) events of an order
      def index

        if params['customer_order_id'] == 0 then
          @order_events = []

        else
          @order_events = CustomerOrderEvent.includes(:event_type, :user).where(order_id: params['customer_order_id']).map do |o|
            {
              id:           o.id,
              eventDate:    o.event_datetime,
              eventName:    o.event_type.name,
              observations: o.observations,
              eventUser:    o.user.email
            }
          end
        end

        respond_to do |format|
          format.json { render json: @order_events }
        end
      end

    end
  end
end