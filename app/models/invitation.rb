class Invitation < ActiveRecord::Base
  before_create :generate_token
  belongs_to :inviter, foreign_key: 'user_id', class_name: 'User'
  validates_presence_of :recipient_email, :recipient_name, :message

  def generate_token
    self.token = SecureRandom.urlsafe_base64      
  end
    
end