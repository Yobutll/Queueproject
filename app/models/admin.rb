class Admin < ApplicationRecord
    has_secure_password
    validates :username, presence: true, uniqueness: true
    validates :password, presence: true
    has_many :token

    def password=(p)
        @password = p
        self.password_digest = self.class.encrypt(p)
    end

    def self.encrypt(p)
        Digest::SHA512.hexdigest("=#{'dsad'}#{p}#{'dsadasss'}")
    end
end
