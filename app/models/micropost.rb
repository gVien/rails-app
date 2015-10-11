class Micropost < ActiveRecord::Base
  belongs_to :user
  # -> is “stabby lambda” syntax for an object called a Proc (procedure) or lambda
  default_scope -> { order(created_at: :desc) } # create default order for microposts
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140} # or { in: 1..140 }
end
