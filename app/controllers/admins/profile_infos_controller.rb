class Admins::ProfileInfosController < ApplicationController
    before_action :authenticate_admin_from_token!
    before_action :set_profile_info
  
    # GET /admins/profile_info
    def show
      render json: @profile_info
    end
  
    # PATCH/PUT /admins/profile_info
    def update
      if @profile_info.update(profile_info_params)
        render json: @profile_info
      else
        render json: { errors: @profile_info.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    private
  
    def set_profile_info
      @profile_info = ProfileInfo.find(1)
    rescue ActiveRecord::RecordNotFound
      @profile_info = ProfileInfo.create(id: 1)
    end
  
    def profile_info_params
      params.require(:profile_info).permit(:about_me, :years_experience, :client_satisfaction, :projects_completed)
    end
  
    def authenticate_admin_from_token!
      token = request.headers['Authorization']&.split(' ')&.last
  
      unless token
        render json: { error: 'No token provided' }, status: :unauthorized
        return
      end
  
      begin
        decoded_token = JWT.decode(token, ENV['DEVISE_JWT_SECRET_KEY'], true, { algorithm: 'HS256' })
        # Use an instance variable that doesn't conflict with Devise's potential current_admin
        @current_admin_user = Admin.find(decoded_token[0]['sub'])
      rescue JWT::DecodeError, ActiveRecord::RecordNotFound
        render json: { error: 'Invalid token' }, status: :unauthorized
      end
    end  
  end