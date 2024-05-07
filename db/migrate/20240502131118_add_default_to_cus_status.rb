class AddDefaultToCusStatus < ActiveRecord::Migration[7.1]
  def change
    change_column_default :queue_users, :cusStatus, from: nil, to: "1"
  end
end
