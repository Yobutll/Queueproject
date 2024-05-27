class Deletecolumncus < ActiveRecord::Migration[7.1]
  def change
    remove_column :customers, :status, :boolean
    remove_column :customers, :expired, :datetime
  end
end
