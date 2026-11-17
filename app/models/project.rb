class Project < ApplicationRecord
  has_many_attached :photos
  has_many_attached :videos

  before_create :set_default_position
  before_validation :clean_youtube_urls

  default_scope { order(position: :asc) }

  private

  def set_default_position
    self.position = (Project.maximum(:position) || -1) + 1
  end

  # Remove blank entries and duplicates so the admin UI can send empty rows.
  def clean_youtube_urls
    self.youtube_urls = Array(youtube_urls).map(&:to_s).map(&:strip).reject(&:blank?).uniq
  end
end