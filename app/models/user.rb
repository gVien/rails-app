class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email # can be upcase, make email to be uniform so that it is case insensitive before saving to database
  before_create :create_activation_digest   # before create the user (e.g. User.new), assign the activatio token & digest
  validates :name, :presence => true, :length => { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, :presence => true, :length => { maximum: 255 }, :format => { with: VALID_EMAIL_REGEX }, :uniqueness => { case_sensitive: false }
  has_secure_password

  # allow_nil is true seems like the new users are allowed to have empty password
  # but this is not the case, as has_secure_password includes a separate presence validation
  # that specifically catches nil passwords (i.e. does not allow empty password)
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

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
    self.remember_token = User.new_token  # note self refers to the instance of User class while User refers to the class method
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # returns true if the given token matches the digest
  # this is similar to authenticate method from BCrypt
  # this generalize method works for any attribute (remember_digest, activation_digest, etc)
  # example => authenticated(:remember, remember_token)
  def authenticated?(attribute, token)
    # metaprogramming is a program that writes program
    # example of metaprogramming using send method
    # SEND method lets us call a method with a name of our choice by “sending a message” to a given object
    # EXAMPLE
    # user = User.first
    # user.activation_digest => "$2a$10$4e6TFzEJAVNyjLv8Q5u22ensMt28qEkx0roaZvtRcp6UZKRM6N9Ae"
    # user.send(:activation_digest) => "$2a$10$4e6TFzEJAVNyjLv8Q5u22ensMt28qEkx0roaZvtRcp6UZKRM6N9Ae"
    # user.send('activation_digest') => "$2a$10$4e6TFzEJAVNyjLv8Q5u22ensMt28qEkx0roaZvtRcp6UZKRM6N9Ae"
    # attribute = :activation
    # user.send("#{attribute}_digest") => "$2a$10$4e6TFzEJAVNyjLv8Q5u22ensMt28qEkx0roaZvtRcp6UZKRM6N9Ae"

    digest = send("#{attribute}_digest")
    return false if digest.nil?  #accounts for the multiple browsers that try to log out of the site
    BCrypt::Password.new(digest).is_password?(token)  # note this is the same as BCrypt::Password.new(remember_digest) == remember_token but it is clearer
  end

  # method to forget a user
  def forget
    update_attribute(:remember_digest, nil)
  end

  # lower case email (case insensitive)
  def downcase_email
    self.email = email.downcase
  end

  # this creates the activation token and digest for account activation
  # a newly signed up user will have activation token and digest assigned to each user object
  # before it's created (uses before_create callback)

  def create_activation_digest
    self.activation_token = User.new_token  # note self refers to the instance of User class while User refers to the class method
    # similar to the remember method above but we won't be using `update_attribute` since we are not updating the attribute this time
    # the difference this time is that the remember tokens and digests are created for users that already exist in the database,
    # whereas the before_create callback happens before the user has been created.
    self.activation_digest = User.digest(activation_token)
  end

  # this method activates an account
  def activate
    self.update_attribute(:activated, true) # the self here is optional, since we don't have to use self inside the model. but putting it here for clarity
    self.update_attribute(:activated_at, Time.zone.now)
  end

  # send activation link via email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now # self is the receiver of this method
  end

  # similar to create_activation_digest to create reset token & digest
  # note the use of update_attribute since attribute is already in the database
  def create_reset_digest
    # create reset token and make it attribute accessible
    # to be used in reset url, for example
    # /password_resets/[reset_token]/edit?email=example%40railstutorial.org
    self.reset_token = User.new_token
    self.update_attribute(:reset_digest, User.digest(reset_token))  # the self here is optional, since we don't have to use self inside the model. but putting it here for clarity
    self.update_attribute(:reset_sent_at, Time.zone.now)
  end

  # send reset email instruction to user
  def send_password_reset_email
   UserMailer.password_reset(self).deliver_now # self is the receiver of this method
  end

  # returns true if password is expired, false otherwise
  def password_reset_expired?
    self.reset_sent_at < 2.hours.ago
  end
end
