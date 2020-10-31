source 'https://rubygems.org'

# Set Ruby version (for Heroku).
# Remember to match .travis.yml and rbenv versions.
ruby "2.5.8"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.8'

# Use sqlite3 as the database for Active Record
#gem 'sqlite3'
gem 'pg'

# Bootstrap/SCSS
# https://github.com/twbs/bootstrap-sass
gem 'bootstrap-sass', '~> 3.3.4'
gem 'sass-rails', '>= 3.2'
gem 'font-awesome-sass'
gem 'bootstrap-sass-extras'
gem 'bootstrap-datepicker-rails'
gem 'bootstrap-typeahead-rails'

# Slim: https://github.com/slim-template/slim-rails
gem "slim-rails"

# Pagination
gem 'kaminari'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .coffee assets and views
#gem 'coffee-rails', '~> 4.1.0'

# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# CSV parsing
gem 'smarter_csv'

# Use Rubyzip for zipped MailChimp export files
gem 'rubyzip'

# Search classes
gem 'searchlight'

# Email validation
gem 'valid_email', :require => 'valid_email/email_validator'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
gem 'unicorn'

# Development Gems
group :development do
  # Use Capistrano for deployment
  gem 'capistrano-rails'

  # Suppress asset logging on dev server
  gem 'quiet_assets'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Rename project
  gem 'rename'
end

# Development/Test Gems
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'



  # Spring speeds up development by keeping your application running in the background.
  # Read more: https://github.com/rails/spring
  gem 'spring'

  # Console debugger
  gem 'pry'

  # Catch n+1 queries
  gem 'bullet'
end
