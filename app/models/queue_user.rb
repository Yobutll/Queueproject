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
        max_qNumber = QueueUser.maximum(:qNumber).to_i || 0
        self.qNumber = (max_qNumber + 1).to_s
    end

    def set_queue_finish_at
      self.cusTimeEnd = Time.now
    end
end
