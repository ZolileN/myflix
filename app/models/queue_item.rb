class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  delegate :categories, to: :video
  delegate :title, to: :video, prefix: :video

  validates_uniqueness_of :user_id, scope: [:video_id]
  validates_numericality_of :position, {only_integer: true}
  
  def rating
    review
    review.rating if review
  end

  def rating=(new_rating)
    review
    if review
      review.update_column(:rating, new_rating)
    else
      review = Review.new(user: user, video: video, rating: new_rating)
      review.save(validate: false)
    end
  end

  private

  def review
    @review ||= Review.where(user_id: user.id, video_id: video.id).first
  end
end