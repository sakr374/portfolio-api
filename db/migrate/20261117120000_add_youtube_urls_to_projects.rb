class AddYoutubeUrlsToProjects < ActiveRecord::Migration[8.0]
  def change
    add_column :projects, :youtube_urls, :text, array: true, default: []
  end
end
