class AddArtistToAlbum < ActiveRecord::Migration[8.1]
  def change
    add_reference :albums, :artist, null:false
  end
end
