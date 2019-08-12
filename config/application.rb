require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Mvpinvest
  class Application < Rails::Application
    config.generators do |generate|
      generate.assets false
      generate.helper false
      generate.test_framework  :test_unit, fixture: false
    end

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    #Joaquim: Setting time zone
    config.time_zone = 'Brasilia'
    config.active_record.default_timezone = :local

    #Joaquim: Configuring sidekiq
    config.active_job.queue_adapter = :sidekiq

    #Joaquim: Setting portuguaise language for devise
    config.i18n.default_locale = :'pt-BR'

  [
    'app/services/credit_analysis',
    'app/services/data_parsing',
    'app/services/googlespreadsheets',
    'app/services/sign_documents',
    'app/services/slack',
  ].each do |path|
    config.autoload_paths << path
  end

  end
end
