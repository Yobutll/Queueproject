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

    Dotenv.load
     
    def push_message_calling(uid_Line)    
      if cusStatus == "3"
          message_data = {
          to: customer.uidLine,
          messages: [
              { type: "text", text: "เสร็จสิ้นแล้วขอบคุณที่ใช้บริการ" },
            ]
          }
      end
      if cusStatus == "2"
        message_data = {
          to: customer.uidLine,
          messages: [
              { type: "text", text: "ถึงคิวของคุณแล้วกรุณาไปที่หน้าแคชเชียร์" },
            ]
          }
      end
      if cusStatus == "1"
        message_data = {
          to: customer.uidLine,
          messages: [
              { type: "text", text: "จองคิวสำเร็จ \nหมายเลขคิวปัจจุบันของคุณคือ #{self.qNumber} \nจำนวนลูกค้า #{self.cusSeat}" },
            ]
          }
      end
      if cusStatus == "0"
        message_data = {
          to: customer.uidLine,
          messages: [
              { type: "text", text: "ยกเลิกคิวสำเร็จ" },
            ]
          }
      end
        message_json = JSON.dump(message_data)
        url = "https://api.line.me/v2/bot/message/push"
        response = Faraday.post(url) do |req|
            req.headers['Content-Type'] = 'application/json'
            req.headers['Authorization'] = "Bearer FfG86IKwyV5kNy4EX8q3OlpS8X3xUxscyGFamzqtRDLlKmNjdvTkqDz8ic1v5jRK56AOaJa8fR4Ge6oMNdXmLClwbJO6ocgtH9nu2WWc+Qpaug7s3c7aFymI6sqmDTPFtPrZD2B7Mo+u0o2B+2oYoQdB04t89/1O/w1cDnyilFU="
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
      max_qNumber = QueueUser.all.sort_by { |q| [q.qNumber[0], q.qNumber[1..-1].to_i] }.last&.qNumber
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
        self.qNumber = letter + number.to_s.rjust(3, '00')
      else
        self.qNumber = "A001"
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
