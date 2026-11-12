class AddAlbumToSong < ActiveRecord::Migration[8.1]
  def change
    add_reference :songs, :album, null: false
  end
end
