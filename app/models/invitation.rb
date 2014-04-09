class Invitation < ActiveRecord::Base
  include Tokenable

  before_create :generate_token
  belongs_to :inviter, foreign_key: 'user_id', class_name: 'User'
  validates_presence_of :recipient_email, :recipient_name, :message    
end