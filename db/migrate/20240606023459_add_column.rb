class AddColumn < ActiveRecord::Migration[7.1]
  def change
    add_column :queue_users, :callCount, :integer
  end
end
