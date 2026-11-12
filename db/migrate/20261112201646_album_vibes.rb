class AlbumVibes < ActiveRecord::Migration[8.1]
  def change
    create_table :album_vibes do |t|
      t.references :album, null: false
      t.references :vibe, null: false
      t.timestamps
    end
  end
end
