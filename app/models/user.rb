class User < ActiveRecord::Base
  before_save { self.email = email.downcase }  # can be upcase, make email to be uniform so that it is case insensitive before saving to database
  validates :name, :presence => true, :length => { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true, :length => { maximum: 255 }, :format => { with: VALID_EMAIL_REGEX }, :uniqueness => { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
end
