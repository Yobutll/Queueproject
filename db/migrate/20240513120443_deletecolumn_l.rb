class DeletecolumnL < ActiveRecord::Migration[7.1]
  def change
    remove_column :tokens, :expiredLine, :string
  end
end
