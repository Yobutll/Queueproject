class Customer < ApplicationRecord
    has_many :tokens
    has_many :queue_users
    after_save :save_queue
    validates :uidLine, presence: true, uniqueness: true
    attr_accessor :queueNew

    def save_queue
      if queueNew
        queueNew.each do |queueNew|
          obj = QueueUser.new(queueNew)
          obj.customer_id = self.id
          obj.save
          puts queueNew.inspect
        end
      end
          puts "Queue saved"
    end 

  
  
end