ForestLiana.env_secret = Rails.application.credentials.development[:forest_env_secret] if Rails.env.development?
ForestLiana.env_secret = Rails.application.credentials.production[:forest_env_secret] if Rails.env.production?
ForestLiana.auth_secret = Rails.application.credentials.development[:forest_auth_secret] if Rails.env.development?
ForestLiana.auth_secret = Rails.application.credentials.production[:forest_auth_secret] if Rails.env.production?
