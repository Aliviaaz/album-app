class Vibe < ApplicationRecord
    has_many :song_vibes
    has_many :songs, through: :song_vibes
    has_and_belongs_to_many :albums
end
