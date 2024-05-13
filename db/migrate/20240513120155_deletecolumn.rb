class Deletecolumn < ActiveRecord::Migration[7.1]
  def change
    remove_column :tokens, :tokenLineID, :string
    remove_column :tokens, :customer_id, :integer
  end
end
