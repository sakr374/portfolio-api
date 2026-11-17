class Api::V1::ProfileInfosController < Api::V1::BaseController
    # GET /api/v1/profile_info
    def show
      profile_info = ProfileInfo.find(1) # Assuming ID=1
      render json: profile_info
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Profile information not found' }, status: :not_found
    end
  end