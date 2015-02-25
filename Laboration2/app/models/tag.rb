class Tag < ActiveRecord::Base
  has_and_belongs_to_many :events

  include Rails.application.routes.url_helpers

  before_save{self.name = name.downcase}
  validates :name, presence: true, case_sensitive: false

  def serializable_hash (options={})
    options = {

    }.update(options)

    json = super(options)
    json['url'] = self_link
    json
  end


  def self_link
    #  the configuration is set i config/enviroment/{development|productions}.rb
    "#{Rails.configuration.baseurl}#{api_tag_path(self)}"
  end
end
