class QueueUser < ApplicationRecord
    before_save :set_queue_finish_at, if: :status_changed_to_3?
    belongs_to :customer , optional: true
    before_create :set_qNumber
    after_update :notify_if_status_changed_to_2
    
    require 'faraday'
    require 'json'
    
    Dotenv.load
    
    def push_message_calling(uid_line)    
        message_data = {
        to: uid_line,
        messages: [
            { type: "text", text: "ถึงคิวของคุณแล้วกรุณาไปที่หน้าแคชเชียร์" },
            
          ]
        }
        message_json = JSON.dump(message_data)
        url = "https://api.line.me/v2/bot/message/push"
    
        response = Faraday.post(url) do |req|
            req.headers['Content-Type'] = 'application/json'
            req.headers['Authorization'] = "Bearer #{ENV['LINE_CHANNEL_TOKEN']}"
            req.body = message_json
            
        end
        puts "response: #{response.body}"
    end

    private
    def status_changed_to_3?
      cusStatus_changed? && cusStatus == "3"
    end

    def set_qNumber
      max_qNumber = QueueUser.all.sort_by { |q| [q.qNumber[0], q.qNumber[1..-1].to_i] }.last&.qNumber
      if max_qNumber
        letter = max_qNumber[/[A-Za-z]+/] || "A"
        number = max_qNumber[/\d+/].to_i
        number += 1
        if number <= 999
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

    def set_queue_finish_at
      self.cusTimeEnd = Time.now
    end
    
    def notify_if_status_changed_to_2
      if saved_change_to_cusStatus? && cusStatus == "2"
        push_message_calling(customer.uidLine)
      end
    end
   
end
