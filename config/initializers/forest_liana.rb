ForestLiana.env_secret = Rails.application.credentials[Rails.env.to_sym][:forest_env_secret]
ForestLiana.auth_secret = Rails.application.credentials[Rails.env.to_sym][:forest_auth_secret]
