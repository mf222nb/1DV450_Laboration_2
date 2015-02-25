class Creator < ActiveRecord::Base
  has_many :events

  validates :name, presence: true
  validates :password_digest, length: {maximum: 255}, presence: true
  has_secure_password

  include Rails.application.routes.url_helpers

  def serializable_hash (options={})
    options = {

        only: [:id, :name, :created_at, :updated_at]

    }.update(options)

    json = super(options)
    json['url'] = self_link
    json
  end


  def self_link
    #  the configuration is set i config/enviroment/{development|productions}.rb
    "#{Rails.configuration.baseurl}#{api_creator_path(self)}"
  end
end
