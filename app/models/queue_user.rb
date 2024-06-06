  require 'faraday'
  require 'json'
class QueueUser < ApplicationRecord
    before_save :set_queue_finish_at, if: :status_changed_to_3?
    belongs_to :customer , optional: true
    before_create :set_qNumber
    after_update :notify_if_status_changed
    after_create :notify_if_queue_created
    validates :cusName, presence: true
    validates :cusSeat, presence: true 
    attr_accessor :is_admin
    Dotenv.load

    def push_message_calling(uid_Line,is_admin) 
      if cusStatus == "2" && callCount == 0
        message_data = {
          to: customer.uidLine,
          messages: [
              { type: "text", text: "ถึงคิวของคุณแล้ว\nเชิญที่เคาท์เตอร์บริการค่ะ" },
            ]
          }
      end
      if cusStatus == "2" && callCount >= 1
        message_data = {
          to: customer.uidLine,
          messages: [
              { type: "text", text: "ทางเราขอเรียนแจ้งว่าหากท่านไม่สามารถมาตามนัดได้ภายในเวลาที่กำหนด ทางเราจำเป็นต้องขอยกเลิกคิวของท่าน เพื่อให้บริการลูกค้าท่านอื่นที่รออยู่" },
            ]
          }
      end
      if cusStatus == "1"
        message_data = {
          to: customer.uidLine,
          messages: [
              { type: "text", text: "จองคิวสำเร็จ ✅ \nคิวปัจจุบันของคุณคือ #{self.qNumber} \nจำนวนลูกค้า #{self.cusSeat} ท่าน" },
            ]
          }
      end
      if cusStatus == "0"
        if is_admin
          message_data = {
            to: customer.uidLine,
            messages: [
                { type: "text", text: "คิวของคุณถูกยกเลิกโดย admin \nกรุณาติดต่อ admin หากมีข้อสงสัย" },
              ]
            }
        else
          message_data = {
            to: customer.uidLine,
            messages: [
                { type: "text", text: "คุณได้ทำการยกเลิกคิวแล้ว \nกรุณากดบัตรคิวหากต้องการดำเนินการใหม่อีกครั้ง <#{is_admin}>" },
              ]
            }
        end
      end
        message_json = JSON.dump(message_data)
        url = "https://api.line.me/v2/bot/message/push"
        response = Faraday.post(url) do |req|
            req.headers['Content-Type'] = 'application/json'
            req.headers['Authorization'] = "Bearer nhdIYE2t+or1JQxftDXF5hCXKMWz9MaAVZnkK/kdm+MDbyRpuGTvbau7NDpfccrPyiYSPS4Eyb+lZCnyGYCqchJon2uZ6p+6UaxdsIlgh7WiwqGkQvTDwuVABWnMZHK9iDlObuYQiq9TSTxNm6YvSgdB04t89/1O/w1cDnyilFU="
            req.body = message_json
        end
        puts "response: #{response.body}"
    end

    def notify_if_queue_called_again
      is_admin = ApplicationController.new.instance_variable_get(:@is_admin)
      if cusStatus == "2" && callCount <= 1
        push_message_calling(customer.uidLine,is_admin)
        self.update(callCount: callCount + 1)
        ActionCable.server.broadcast('QueueManagmentChannel', {action: 'update', queue: self})
      else
        puts "Queue is not calling"
      end
    end


    def set_qNumber
      ActiveRecord::Base.transaction do
        last_queue_user = QueueUser.order(qNumber: :desc).lock.first
        new_qNumber = last_queue_user ? last_queue_user.qNumber.next : 'A01'
        while QueueUser.exists?(qNumber: new_qNumber)
          if new_qNumber[-2..-1] == '99'
            new_qNumber = new_qNumber[0].next + '01'
          else
            new_qNumber = new_qNumber.next
          end
        end
        self.qNumber = new_qNumber
      end
    end

    private
    def status_changed_to_3?
      cusStatus_changed? && (cusStatus == "3" || cusStatus == "0")
    end

    def set_queue_finish_at
      self.cusTimeEnd = Time.now
    end
    
    def notify_if_queue_created
      is_admin = ApplicationController.new.instance_variable_get(:@is_admin)
        push_message_calling(customer.uidLine,is_admin)
    end
    
    def notify_if_status_changed
      is_admin = ApplicationController.new.instance_variable_get(:@is_admin)
      if saved_change_to_cusStatus? 
        push_message_calling(customer.uidLine,is_admin)
      end
    end
   
end
