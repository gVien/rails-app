if Rails.env.production?
  CarrierWave.config do |config|
    config.fog_credentials = {
      # configuration for AWS S3 with AWS IAM Access
      # note these variables must be set on Heroku side
      :provide              => "AWS",
      :aws_access_key_id    => ENV["S3_ACCESS_KEY"],
      :aws_secret_key_id    => ENV["S3_SECRET_KEY"]
    }
    config.fog_directory    = ENV["S3_BUCKET"]
  end
end