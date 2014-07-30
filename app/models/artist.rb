class Artist < ActiveRecord::Base
  has_many :tracks
  has_and_belongs_to_many :genres
end
