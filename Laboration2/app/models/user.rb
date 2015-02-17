class User < ActiveRecord::Base

  has_many :keys, :dependent => :destroy

  before_save{self.name = name.downcase}

  validates :password_digest, length: {maximum: 255}, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length: {maximum: 255},
      format: {with: VALID_EMAIL_REGEX},
      uniqueness: {case_sensitive: false}
  has_secure_password
end
