class AddcustomerqueueUser < ActiveRecord::Migration[7.1]
  def change
    add_reference :queue_users, :customer, foreign_key: true
    add_reference :tokens, :customer, foreign_key: true
    add_reference :tokens, :admins, foreign_key: true
  end
end
