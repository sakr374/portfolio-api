class Admins::ProjectsController < ApplicationController
  before_action :authenticate_admin_from_token!
  before_action :set_project, only: [:update, :destroy]

  def index
    @projects = Project.all
    # Use the same serializer as the public controller to keep the data format
    options = { params: { url_helpers: Rails.application.routes.url_helpers } }
    render json: ProjectSerializer.new(@projects, options).serializable_hash, status: :ok
  end

  def create
    @project = Project.new(project_params)
    
    if @project.save
      render json: {
        status: { code: 201, message: 'Project created successfully.' },
        data: ProjectSerializer.new(@project, params: { url_helpers: Rails.application.routes.url_helpers }).serializable_hash[:data]
      }, status: :created
    else
      render json: {
        status: { code: 422, message: 'Failed to create project.' },
        errors: @project.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def update
    # --- START OF MODIFICATIONS ---

    # 1. Handle removals first (if any are provided)
    if project_params[:attachment_ids_to_remove].present?
      project_params[:attachment_ids_to_remove].each do |attachment_id|
        attachment = ActiveStorage::Attachment.find_by(id: attachment_id)
        
        # Use purge_later to run deletion in a background job
        attachment.purge_later if attachment&.record == @project
      end
    end

    # 2. Separate scalar (text) params from file params
    # We exclude the file arrays and our custom removal array.
    scalar_params = project_params.except(:attachment_ids_to_remove, :photos, :videos)
    
    # 3. Update the project's text fields first
    if @project.update(scalar_params)
      
      # 4. Attach new photos, if any were uploaded
      if project_params[:photos].present?
        @project.photos.attach(project_params[:photos])
      end

      # 5. Attach new videos, if any were uploaded
      if project_params[:videos].present?
        @project.videos.attach(project_params[:videos])
      end

      # 6. Render success response
      render json: {
        status: { code: 200, message: 'Project updated successfully.' },
        # We .reload to make sure the serializer gets the newly attached files
        data: ProjectSerializer.new(@project.reload, params: { url_helpers: Rails.application.routes.url_helpers }).serializable_hash[:data]
      }, status: :ok
    
    else
      # 7. Render failure response (if title/description update failed)
      render json: {
        status: { code: 422, message: 'Failed to update project.' },
        errors: @project.errors.full_messages
      }, status: :unprocessable_entity
    end

    # --- END OF MODIFICATIONS ---
  end

  def destroy
    if @project.destroy
      render json: {
        status: { code: 200, message: 'Project deleted successfully.' }
      }, status: :ok
    else
      render json: {
        status: { code: 422, message: 'Failed to delete project.' },
        errors: @project.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def reorder
    project_ids = params[:project_ids] || params.dig(:project, :project_ids)
    if project_ids.nil?
      return render json: { status: 'error', message: 'project_ids parameter is missing' }, status: :unprocessable_entity
    end
    Project.transaction do
      project_ids.each_with_index do |id, index|
        Project.where(id: id).update_all(position: index)
      end
    end
    render json: { status: 'success', message: 'Project order updated.' }, status: :ok
  rescue => e
    Rails.logger.error "Reorder failed: #{e.message}"
    render json: { status: 'error', message: e.message }, status: :unprocessable_entity
  end

  private

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

  def set_project
    @project = Project.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      status: { code: 404, message: 'Project not found.' }
    }, status: :not_found
  end

  def project_params
    params.require(:project).permit(:title, :description, photos: [], videos: [], attachment_ids_to_remove: [], youtube_urls: [])
  end
end