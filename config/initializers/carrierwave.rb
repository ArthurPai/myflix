CarrierWave.configure do |config|
  config.permissions = 0666
  config.directory_permissions = 0777

  if Rails.env.staging? || Rails.env.production?
    config.storage = :fog

    config.fog_credentials = {
        :provider               => 'AWS',                             # required
        :aws_access_key_id      => "#{ENV['AWS_ACCESS_KEY_ID']}",     # required
        :aws_secret_access_key  => "#{ENV['AWS_SECRET_ACCESS_KEY']}", # required
        :region                 => 'ap-northeast-1',                  # optional, defaults to 'us-east-1'
    }
    config.fog_directory  = "#{ENV['AWS_DIRECTORY']}"               # required
    config.fog_public     = true                                    # optional, defaults to true
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
  else
    config.storage = :file
    config.enable_processing = Rails.env.development?
  end
end