class QueueUser < ApplicationRecord
    before_save :set_queue_finish_at, if: :status_changed_to_3?
    belongs_to :customer , optional: true
    before_create :set_qNumber

  

    def set_queue_number
        # Use a PostgreSQL sequence to generate unique queue numbers
        self.queue_number = ActiveRecord::Base.connection.execute("SELECT nextval('queue_number_seq')").getvalue(0, 0)
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
        if number == 999
          letter = letter.next
          number = 1
        end
        if letter == "Z" && number == 999
          letter = "A"
        end
        self.qNumber = letter + number.to_s.rjust(3, '00')
      else
        self.qNumber = "A001"
      end
    end

    def set_queue_finish_at
      self.cusTimeEnd = Time.now
    end
end
