class Api::V1::ProjectsController < Api::V1::BaseController
  def index
    projects = Project.all.with_attached_photos.with_attached_videos
    # Pass the helpers in the params hash
    options = { params: { url_helpers: Rails.application.routes.url_helpers } }
    render json: ProjectSerializer.new(projects, options).serializable_hash.to_json
  end

  def show
    project = Project.find(params[:id])
    # Pass the helpers in the params hash here as well
    options = { params: { url_helpers: Rails.application.routes.url_helpers } }
    render json: ProjectSerializer.new(project, options).serializable_hash.to_json
  end
end