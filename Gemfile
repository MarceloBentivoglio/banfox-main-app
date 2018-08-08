source 'https://rubygems.org'
ruby '2.3.5'

gem 'devise'
gem 'jbuilder', '~> 2.0'
gem 'pg', '~> 0.21'
gem 'puma'
gem 'rails', '5.2.0'
gem 'redis'

gem 'autoprefixer-rails'
gem 'bootstrap-sass', '~> 3.3'
gem 'font-awesome-sass', '~> 5.0.13'
gem 'sass-rails'
gem 'simple_form'
gem 'uglifier'
gem 'webpacker'

# Used to create authorizations on our application
gem "pundit"

# Used to create the wizard (or multistep form) of the client
gem 'wicked'

# This gem is used to enable enum to become a selection in simple_form
gem 'enum_help'

#   This gem treats money as cents in integer with the respective currency
gem 'money-rails' #https://github.com/RubyMoney/money-rails

# These two gems are used for validating the CPF and the CNPJ
gem 'cpf_cnpj'

# This gem is used to create an admin interface
gem 'forest_liana'

# This gem is used to transform images that are uploaded by the user
gem 'mini_magick'

# This gem is used to create and admin interface that allows to accesss
# attachments from Active Storage
gem 'rails_admin'

# These 2 gems are used to make an interface between amazon S3 and heroku. This
# enables us to make the upload of clients' documents and store them on amazon
gem 'aws-sdk'
gem "aws-sdk-s3", require: false

# This gem is used to read xlsx files so that we can convert the data inside the file into ruby objects
gem 'creek'

# This gem is used to create pagination and to create the endless / infinite scrolling
gem 'will_paginate', '~> 3.1.0'

# This gem is used to write our data on the google spreadsheet
gem 'google-api-client', '~> 0.23.4'

# This gem is used to enable the background jobs asynchronosly
gem 'sidekiq'
gem 'sidekiq-failures', '~> 1.0'

# This gem is used to show backend errors on production
gem 'rollbar'

group :development do
  gem 'web-console', '>= 3.3.0'
  gem "letter_opener"
end

group :development, :test do
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
