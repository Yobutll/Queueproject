class Customer < ApplicationRecord
    has_many :tokens
    has_many :queue_users
    after_save :save_queue

    attr_accessor :queueNew

    def save_queue
        if self.queueNew.present?
          self.queueNew.each do |queue_data|
            queue = self.queue_users.build(queue_data.permit(:cusName, :cusPhone, :cusSeat))
            queue.customer_id = self.id
            puts queue.inspect
            queue.save!
          end
          puts "Queue saved"
        else
          puts "No queue data provided"
        end
      end

    
end
