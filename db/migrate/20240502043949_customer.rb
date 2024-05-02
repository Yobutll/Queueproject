class Customer < ActiveRecord::Migration[7.1]
  def change
    add_column :customers, :uidLine, :string
  end
end
