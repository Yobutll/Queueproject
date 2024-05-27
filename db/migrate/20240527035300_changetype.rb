class Changetype < ActiveRecord::Migration[7.1]
  def change
    change_column_default :customers, :status, from: nil, to: true
    change_column :customers, :tokenLine, :string
  end
end
