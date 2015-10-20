class Relationship < ActiveRecord::Base
  # class name refers the follower and followed to a user in the User model
  # since convention is broken
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
