class Position < ActiveRecord::Base
  has_many :events

  validates :long, presence: true
  validates :lat, presence: true
end
