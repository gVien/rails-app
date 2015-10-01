class User < ActiveRecord::Base
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
end
