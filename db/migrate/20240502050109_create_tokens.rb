class CreateTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :tokens do |t|
      t.string :tokenLineID
      t.string :tokenAdmin
      t.string :expiredLine
      t.string :expiredAdmin
      t.timestamps
    end
  end
end
