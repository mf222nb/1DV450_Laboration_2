class Event < ActiveRecord::Base
  has_and_belongs_to_many :tags
  belongs_to :creator
  belongs_to :position

  validates :description, presence: true
  validates :title, presence: true

  include Rails.application.routes.url_helpers

  def serializable_hash (options={})
    options = {
        # declare what we want to show
        include: {:position => {only: [:long, :lat]}, :creator => {only: [:name]}, :tags => {only: [:name]}},
        only: [:id, :creator_id, :position_id, :title,:description, :created_at, :updated_at]
    }.update(options)

    json = super(options)
    json['url'] = self_link
    json
  end


  def self_link
    #  the configuration is set i config/enviroment/{development|productions}.rb
    "#{Rails.configuration.baseurl}#{api_event_path(self)}"
  end

end
