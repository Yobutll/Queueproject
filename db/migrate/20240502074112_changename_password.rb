class ChangenamePassword < ActiveRecord::Migration[7.1]
  def change
    rename_column :admins, :password, :password_digest
  end
end
