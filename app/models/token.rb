class Token < ApplicationRecord
  belongs_to :customer, optional: true
  belongs_to :admin, optional: true


  private
  def ensure_customer_is_token_user
    if customer_id.present? && customer_id != tokens_user
      errors.add(:customer_id, "must be equal to tokens_user")
    end
  end      
end
