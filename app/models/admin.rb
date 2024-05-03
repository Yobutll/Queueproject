class Admin < ApplicationRecord
    has_secure_password
    validates :username, presence: true, uniqueness: true
    validates :password, presence: true
    has_many :tokens

    def password=(p)
        @password = p
        self.password_digest = self.class.encrypt(p)
    end

    def self.encrypt(p)
        salt = "papa007x?2#Lnwmakmak"
        Digest::SHA512.hexdigest("=#{salt}#{p}#{salt}")
    end

    def encrypt(p)
        self.class.encrypt(p)
    end

  def verify
    self.user_crypted.user_crypted == encrypt(p) if self.user_crypted
  end

  def encrypt_pin_code
    if is_update.blank?
      self.pin_code = encrypt(self.pin_code)
    end
  end
end