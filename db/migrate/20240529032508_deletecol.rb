class Deletecol < ActiveRecord::Migration[7.1]
  def change
    remove_column :customers, :tokenLine, :string

  end
end
