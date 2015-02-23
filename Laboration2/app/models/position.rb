class Position < ActiveRecord::Base
  has_many :events

  validates :long, presence: true
  validates :lat, presence: true

  reverse_geocoded_by :long, :lat
  after_validation :reverse_geocode
end
