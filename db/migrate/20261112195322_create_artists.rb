class CreateArtists < ActiveRecord::Migration[8.1]
  def change
    create_table :artists do |t|
      t.string :name
      t.boolean :is_group

      t.timestamps
    end
  end
end
