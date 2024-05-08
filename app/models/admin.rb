class Admin < ApplicationRecord

    has_secure_password
    validates :username, presence: true, uniqueness: true
    validates :password, presence: true
    #validates :password_digest, presence: true
    has_many :tokens
    after_create :encrypt_pin_code

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
      self.password_digest = encrypt(self.password_digest)
    end

end