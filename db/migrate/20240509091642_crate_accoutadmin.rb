class CrateAccoutadmin < ActiveRecord::Migration[7.1]
  def change
    Admin.create(username: 'atom', password: '1234')
  end
end
