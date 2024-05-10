class Customer < ApplicationRecord
    has_many :tokens
    has_many :queue_users
    after_save :save_queue
    validates :uidLine, presence: true, uniqueness: true
    attr_accessor :queueNew, :tokenNew

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

    def save_token
      if tokenNew
          tok = Token.new(tokenNew)
          tok.customer_id = self.id
          tok.save
      end
    end
  
end