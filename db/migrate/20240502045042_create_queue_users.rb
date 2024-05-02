class CreateQueueUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :queue_users do |t|
      t.string :cusName
      t.string :cusPhone
      t.string :cusSeat
      t.string :cusStatus
      t.string :cusTimeStart
      t.string :cusTimeEnd
      t.timestamps
    end
  end
end
