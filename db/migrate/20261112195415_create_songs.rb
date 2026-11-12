class CreateSongs < ActiveRecord::Migration[8.1]
  def change
    create_table :songs do |t|
      t.string :name
      t.boolean :is_favorite

      t.timestamps
    end
  end
end
