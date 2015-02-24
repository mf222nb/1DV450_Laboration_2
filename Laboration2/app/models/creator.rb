class Creator < ActiveRecord::Base
  has_many :events

  validates :name, presence: true
  validates :password_digest, length: {maximum: 255}, presence: true
  has_secure_password
end
