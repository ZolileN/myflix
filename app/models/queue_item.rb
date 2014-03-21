class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  delegate :categories, to: :video
  delegate :title, to: :video, prefix: :video

  def rating
    review = Review.where(user_id: user_id, video_id: video.id).first
    review.rating if review
  end
end