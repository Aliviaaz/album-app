class Song < ApplicationRecord
    belongs_to :album
    has_many :song_vibes
    has_many :vibes, through: :song_vibes
    validates :name, presence: true
end
