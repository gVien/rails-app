# configuration to skip image resizing during test
if Rails.env.test?
  CarrierWave.configure do |config|
    config.enable_processing = false
  end
end