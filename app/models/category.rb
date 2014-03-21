class Category < ActiveRecord::Base
  has_many :video_categories
  validates_presence_of :name
  has_many :videos, -> { order 'created_at DESC' }, :through => :video_categories

  def recent_videos
    videos.first(6)
  end  

end
