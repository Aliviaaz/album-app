class CreateVibes < ActiveRecord::Migration[8.1]
  def change
    create_table :vibes do |t|
      t.string :name

      t.timestamps
    end
    add_index :vibes, :name, unique: true
  end
end
