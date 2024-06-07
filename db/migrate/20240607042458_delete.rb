class Delete < ActiveRecord::Migration[7.1]
  def change
    remove_column :queue_users, :checkChangeStatusQueueAfterCalledAgain, :boolean
    add_column :queue_users, :checkCallAgain, :integer, default: 0
  end
end
