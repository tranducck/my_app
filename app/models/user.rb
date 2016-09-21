class User < ApplicationRecord
  before_create :email_downcase

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }
  validates :gender, inclusion: { in: ["Male", "Female"] }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  has_secure_password

  private
    def email_downcase
      self.email = self.email.downcase
    end
end
