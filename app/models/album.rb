class Album < ApplicationRecord
    belongs_to :artist
    has_many :songs
    has_and_belongs_to_many :vibes
    has_one_attached :image_url
    validates :title, presence: true
end
