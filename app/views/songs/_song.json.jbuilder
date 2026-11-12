json.extract! song, :id, :name, :is_favorite, :created_at, :updated_at
json.url song_url(song, format: :json)
