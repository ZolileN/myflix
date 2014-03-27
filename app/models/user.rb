class User < ActiveRecord::Base
  has_many :reviews, -> { order 'created_at DESC' }
  has_many :queue_items, -> { order 'position' }
  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id

  has_secure_password validations: false
  validates_presence_of :email, :full_name  
  validates_uniqueness_of :email

  before_create :generate_token

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index+1)
    end 
  end

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end

  def follows?(other_user)
    if following_relationships.map(&:leader).include?(other_user)
      true
    else
      false
    end
  end

  def can_follow?(another_user)
    true unless another_user == self || self.follows?(another_user)
  end

  def generate_token
    self.token = SecureRandom.urlsafe_base64      
  end  

end