CarrierWave.configure do |config|
  config.permissions = 0666
  config.directory_permissions = 0777

  if Rails.env.development? || Rails.env.test?
    config.storage = :file
  else
    config.storage = :fog

    config.fog_credentials = {
        :provider               => 'AWS',                             # required
        :aws_access_key_id      => "#{ENV['AWS_ACCESS_KEY_ID']}",     # required
        :aws_secret_access_key  => "#{ENV['AWS_SECRET_ACCESS_KEY']}", # required
        :region                 => 'Tokyo',                           # optional, defaults to 'us-east-1'
    }
    config.fog_directory  = "#{ENV['AWS_DIRECTORY']}"               # required
    config.fog_public     = true                                    # optional, defaults to true
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
  end
end