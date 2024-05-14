class AddStatusToken < ActiveRecord::Migration[7.1]
  def change
    add_column :tokens, :status, :boolean
  end
end
