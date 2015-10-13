class Micropost < ActiveRecord::Base
  belongs_to :user
  # -> is “stabby lambda” syntax for an object called a Proc (procedure) or lambda
  default_scope -> { order(created_at: :desc) } # create default order for microposts
  # carrierwave method to associate the picture attribute with the model,
  # :picture is the attribute and PictureUploader is the class in /upload/picture_uploader.rb
  mount_uploader(:picture, PictureUploader)
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140} # or { in: 1..140 }
  validate :picture_size  # second validation to set file size limit

  private
    # second validation/constraint: file size (server side)
    # limit
    def picture_size
      if picture.size > 5.megabytes # or self.picture.size
        errors.add("File size cannot be bigger than 5MB")
      end
    end
end
