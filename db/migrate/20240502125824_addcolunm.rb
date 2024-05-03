class Addcolunm < ActiveRecord::Migration[7.1]
  def change
    add_column :queue_users, :qNumber, :string
  end
end
