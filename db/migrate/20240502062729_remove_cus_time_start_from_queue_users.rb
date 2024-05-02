class RemoveCusTimeStartFromQueueUsers < ActiveRecord::Migration[7.1]
  def change
  remove_column :queue_users, :cusTimeStart, :string
  end
end
