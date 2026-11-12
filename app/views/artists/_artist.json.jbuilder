json.extract! artist, :id, :name, :is_group, :created_at, :updated_at
json.url artist_url(artist, format: :json)
