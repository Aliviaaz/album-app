class ChangeDefaultSongsIsFavorite < ActiveRecord::Migration[8.1]
  def change
    change_column_default :songs, :is_favorite, from: nil, to: false
  end
end
