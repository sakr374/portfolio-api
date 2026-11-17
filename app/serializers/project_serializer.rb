class ProjectSerializer
    include JSONAPI::Serializer
    # REMOVE the 'include' line that was here before
  
    attributes :id, :title, :description, :youtube_urls, :created_at, :updated_at
  
    attribute :photos do |object, params| # Notice the 'params' argument here
      if object.photos.attached?
        object.photos.map do |photo|
          {
            id: photo.id,
            # Use the helpers from the passed-in params
            url: params[:url_helpers].rails_blob_url(photo, only_path: true)
          }
        end
      else
        []
      end
    end
  
    attribute :videos do |object, params| # And here
      if object.videos.attached?
        object.videos.map do |video|
          {
            id: video.id,
            # Use the helpers from the passed-in params
            url: params[:url_helpers].rails_blob_url(video, only_path: true)
          }
        end
      else
        []
      end
    end
  end