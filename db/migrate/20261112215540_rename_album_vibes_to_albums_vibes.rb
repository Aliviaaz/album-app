class RenameAlbumVibesToAlbumsVibes < ActiveRecord::Migration[8.1]
  def change
    # Vibe has_and_belongs_to_many :albums, which expects the join table to be named albums_vibes
    rename_table :album_vibes, :albums_vibes
  end
end
