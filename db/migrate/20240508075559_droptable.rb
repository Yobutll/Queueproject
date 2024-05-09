class Droptable < ActiveRecord::Migration[7.1]
  def change
    drop_table :webhooks
  end
end
