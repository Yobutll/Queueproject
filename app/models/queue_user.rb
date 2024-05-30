  require 'faraday'
  require 'json'
class QueueUser < ApplicationRecord
    before_save :set_queue_finish_at, if: :status_changed_to_3?
    belongs_to :customer , optional: true
    before_create :set_qNumber
    after_update :notify_if_status_changed
    after_create :notify_if_queue_created
    validates :qNumber, uniqueness: true
    validates :cusName, presence: true
    validates :cusSeat, presence: true 

    Dotenv.load
     
    def push_message_calling(uid_Line)    
      if cusStatus == "3"
          message_data = {
          to: customer.uidLine,
          messages: [
              { type: "text", text: "เสร็จสิ้นการรอคิว ✅ \nขอให้มีความสุขในการรับประทานอาหารค่ะ 🙇‍♀️" },
            ]
          }
      end
      if cusStatus == "2"
        message_data = {
          to: customer.uidLine,
          messages: [
              { type: "text", text: "ถึงคิวของคุณแล้ว\nเชิญที่เคาท์เตอร์บริการค่ะ" },
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
        message_data = {
          to: customer.uidLine,
          messages: [
              { type: "text", text: "คุณได้ทำการยกเลิกคิวแล้ว \nกรุณากดบัตรคิวหากต้องการดำเนินการใหม่อีกครั้ง" },
            ]
          }
      end
        message_json = JSON.dump(message_data)
        url = "https://api.line.me/v2/bot/message/push"
        response = Faraday.post(url) do |req|
            req.headers['Content-Type'] = 'application/json'
            req.headers['Authorization'] = "Bearer k61TmJguLdKhDdJJqZJyZAF11XJJpIAUs0C7us57zJ90fe/HJeAkxMGdOpWMM7i24Gghg28ezMcajCyfBIXWnIW7HfRUoTDsogYlJJlYNZSj2tlqoAEtZy4EkDzwYQInhhOV35gY17KK3069nJm05gdB04t89/1O/w1cDnyilFU="
            req.body = message_json
            
        end
        puts "response: #{response.body}"
    end

    def notify_if_queue_called_again
      if cusStatus == "2"
        push_message_calling(customer.uidLine)
      end
    end

    def set_qNumber
      # Lock the table to prevent race conditions
      ActiveRecord::Base.transaction do
        max_qNumber = QueueUser.lock.order('"qNumber" DESC').first&.qNumber
        if max_qNumber
          letter = max_qNumber[/[A-Za-z]+/] || "A"
          number = max_qNumber[/\d+/].to_i
          number += 1
          if number >= 999
            letter = letter.next
            number = 1
          end
          if letter == "Z" && number == 999
            letter = "A"
            number = 1
          end
          self.qNumber = letter + number.to_s.rjust(3, '0')
        else
          self.qNumber = "A001"
        end
      end
    end

    private
    def status_changed_to_3?
      cusStatus_changed? && cusStatus == "3"

    end

    def set_queue_finish_at
      self.cusTimeEnd = Time.now
    end
    
    def notify_if_queue_created
        push_message_calling(customer.uidLine)
    end
    
    def notify_if_status_changed
      if saved_change_to_cusStatus? 
        push_message_calling(customer.uidLine)
      end
    end
   
end
