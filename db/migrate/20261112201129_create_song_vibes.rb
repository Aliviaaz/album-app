class CreateSongVibes < ActiveRecord::Migration[8.1]
  def change
    create_table :song_vibes do |t|
      t.references :song, null:false
      t.references :vibe, null:false
      t.timestamps
    end
  end
end
