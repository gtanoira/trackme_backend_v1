module Api
  module V1

    class UsersController < ApplicationController
      
      before_action :set_user, only: [:show]
  
      def index
        @users = User.all
        puts @users
        render json: @users, each_serializer: UserSerializer
      end
  
      def show
      # Validate JWT token
        token_ok, token_error = helpers.API_validate_token(self.request)
        if not token_ok
          render json: {message: token_error }, status: 401
        else
          Rails.logger.info current_user.inspect
          render json: @user, serializer: UserSerializer
        end
      end
  
      def create
        @user = User.new(user_params)
  
        if @user.save
          render json: @user, status: :created, location: @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end
  
      def update
        if @user.update(user_params)
          render json: @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end
  
      def destroy
  
        @user.destroy
      end
  
      private
        def set_user
          @user = User.find(params[:id])
        end
  
        def user_params
          params.require(:user).permit(:first_name, :last_name, :email)
        end
    end
  end
end
