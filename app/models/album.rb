class Album < ApplicationRecord
    belongs_to :artist
    has_many :songs
    has_and_belongs_to_many :vibes
end
