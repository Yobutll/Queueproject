class Changedefault < ActiveRecord::Migration[7.1]
  def change
    change_column_default :queue_users, :callCount, from: nil, to: 0
  end
end
