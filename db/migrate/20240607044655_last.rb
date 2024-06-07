class Last < ActiveRecord::Migration[7.1]
  def change
    remove_column :queue_users, :checkCallAgain, :integer
    add_column :queue_users, :checkChangeStatusQueueAfterCalledAgain, :boolean, default: false
  end
end
