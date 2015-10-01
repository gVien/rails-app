class User < ActiveRecord::Base
  attr_accessor :remember_token
  before_save { self.email = email.downcase }  # can be upcase, make email to be uniform so that it is case insensitive before saving to database
  validates :name, :presence => true, :length => { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, :presence => true, :length => { maximum: 255 }, :format => { with: VALID_EMAIL_REGEX }, :uniqueness => { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  # Now time to test the login functionality of the site (8.2.4).
  # the flow will be the following:
  # 1. Visit the login path.
  # 2. Post valid information to the sessions path.
  # 3. Verify that the login link disappears.
  # 4. Verify that a logout link appears
  # 5. Verify that a profile link appears.
  # in order to do this test, we need to test up BCrypt for the test
  # THIS WILL BE USED WITH THE FIXTURES IN TEST
  # We can create a user fixture with this new method
  def self.digest(string)
    # https://github.com/rails/rails/blob/master/activemodel/lib/active_model/secure_password.rb
    # source from the above link
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    # string is the string that needs to be hash and cost is the computational cost to calculate the hash. The higher the cost, it will be harder to determine the original password
    BCrypt::Password.create(string, cost: cost)
  end

  # method returns a random token
  def self.new_token
    SecureRandom.urlsafe_base64 #uses base 64 to generate a random token (random combination of A–Z, a–z, 0–9, “-”, and “_”)
  end

  # method to remember a user in the dataase for user in persistent sessions
  def remember
    self.remember_token = self.new_token
    update_attribute(:remember_digest, self.digest(remember_token))
  end

  # returns true if the given token matches the digest
  # this is similar to authenticate method from BCrypt
  def authenticated?(remember_token)
    # remember_token is not the same as the accessor (this is a reference, in case there is a confusion in the future)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)  # note this is the same as BCrypt::Password.new(remember_digest).is_password?(remember_token) but it is clearer
  end
end
