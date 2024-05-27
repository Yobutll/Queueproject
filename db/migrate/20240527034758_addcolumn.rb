class Addcolumn < ActiveRecord::Migration[7.1]
  def change
    add_column :customers, :tokenLine, :datetime
    add_column :customers, :status, :boolean
    add_column :customers, :expired, :datetime
  end
end
