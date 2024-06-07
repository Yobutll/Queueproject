class Addpara < ActiveRecord::Migration[7.1]
  def change
    add_column :queue_users, :checkChangeStatusQueueAfterCalledAgain, :boolean, default: false
  end
end
