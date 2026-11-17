class Admins::StatsController < ApplicationController
    # Use the same authentication as your Admins::ProjectsController
    # Make sure authenticate_admin_from_token! is defined correctly
    # If it's in ApplicationController or a concern, this should work.
    # If not, copy the method from Admins::ProjectsController here.
    before_action :authenticate_admin_from_token!
  
    def index
      stat = SiteStat.find_or_create_by(id: 1)
      render json: { visitor_count: stat.visitor_count }, status: :ok
    end
  
    # You might need to add your authentication method here if it's not inherited
    private
  
    # Example copied from Admins::ProjectsController - adjust if needed
    def authenticate_admin_from_token!
      token = request.headers['Authorization']&.split(' ')&.last
  
      unless token
        render json: { error: 'No token provided' }, status: :unauthorized
        return
      end
  
      begin
        decoded_token = JWT.decode(token, ENV['DEVISE_JWT_SECRET_KEY'], true, { algorithm: 'HS256' })
        @current_admin = Admin.find(decoded_token[0]['sub'])
      rescue JWT::DecodeError, ActiveRecord::RecordNotFound
        render json: { error: 'Invalid token' }, status: :unauthorized
      end
    end
  end