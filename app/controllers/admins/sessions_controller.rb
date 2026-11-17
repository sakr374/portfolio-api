class Admins::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    Rails.logger.info "=== LOGIN DEBUG START ==="
    
    begin
      admin_params = sign_in_params
      admin = Admin.find_by(email: admin_params[:email])
      
      if admin&.valid_password?(admin_params[:password])
        Rails.logger.info "Admin authenticated successfully"
        
        # Use Devise's sign_in to trigger JWT generation
        sign_in(:admin, admin)
        
        # Generate JWT token manually using Warden::JWTAuth
        token = Warden::JWTAuth::UserEncoder.new.call(admin, :admin, nil).first
        
        Rails.logger.info "Token generated: #{token.present?}"
        
        render json: {
          status: { code: 200, message: 'Logged in successfully.' },
          data: {
            admin: {
              id: admin.id,
              email: admin.email
            }
          },
          token: token
        }, status: :ok
      else
        Rails.logger.info "Authentication failed"
        render json: {
          status: { code: 401, message: "Invalid email or password." }
        }, status: :unauthorized
      end
      
    rescue => e
      Rails.logger.error "=== ERROR ==="
      Rails.logger.error "Error: #{e.message}"
      Rails.logger.error "Backtrace: #{e.backtrace.first(5).join("\n")}"
      
      render json: {
        status: { code: 500, message: "Internal server error: #{e.message}" }
      }, status: :internal_server_error
    end
  end

  private

  def sign_in_params
    params.require(:admin).permit(:email, :password)
  end

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: {
        status: { code: 200, message: 'Logged in successfully.' },
        data: {
          admin: {
            id: resource.id,
            email: resource.email
          }
        }
      }, status: :ok
    else
      render json: {
        status: { code: 401, message: "Invalid email or password." }
      }, status: :unauthorized
    end
  end

  def respond_to_on_destroy
    if current_admin
      render json: {
        status: 200,
        message: "Logged out successfully."
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end