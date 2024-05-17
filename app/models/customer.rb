class Customer < ApplicationRecord
    has_many :tokens
    has_many :queue_users
    after_save :save_queue
    validates :uidLine, presence: true, uniqueness: true
    attr_accessor :queueNew
    validate :validate
    
   def validate
    if queueNew
      queueNew.each do |queue|
        errors.add(:queueNew, "cusName can't be blank") if queue[:cusName].blank? 
        errors.add(:queueNew, "cusSeat can't be blank") if queue[:cusSeat].blank?
      end
    end
  end
  
    def save_queue
      if queueNew
        queueNew.each do |queueNew|
          obj = QueueUser.new(queueNew)
          obj.customer_id = self.id
            if obj.save
              ActionCable.server.broadcast 'queue_management_channel', {action: 'create', queue: obj}
            else
              puts obj.errors.full_messages
            end
        end
      else
        puts "No queue to save" 
      end
          puts "Queue saved"
    end 
end