source 'https://rubygems.org'

## DEFAULT GEMS BELOW => :default group
gem 'bundler', '~> 1.15.3'
ruby '2.3.1'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1', '>= 5.1.3'
# Use sqlite3 as the database for Active Record
gem 'pg', '~> 0.21.0'
# Use Puma as the app server
gem 'puma', '~> 3.9', '>= 3.9.1'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0', '>= 5.0.6'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 3.2'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2', '>= 4.2.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 4.3', '>= 4.3.1'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5.0', '>= 5.0.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1', '>= 3.1.11'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]


gem 'bootstrap-sass', '~> 3.3', '>= 3.3.7'
gem 'font-awesome-rails', '~> 4.7', '>= 4.7.0.2'
gem 'will_paginate', '~> 3.1', '>= 3.1.6'
gem 'will_paginate-bootstrap', '~> 1.0', '>= 1.0.1'

gem 'daemons', '~> 1.2', '>= 1.2.4'
gem 'delayed_job_active_record', '~> 4.1', '>= 4.1.1'
gem 'delayed_job_web', '~> 1.2', '>= 1.2.10'
gem 'delayed_job', '~> 4.1', '>= 4.1.2'

gem 'mechanize', '~> 2.7', '>= 2.7.5'

gem 'geocoder', '~> 1.4', '>= 1.4.4'
gem 'google_custom_search_api', '~> 2.0'
gem 'google_places', '~> 0.34.2'
gem 'gmaps4rails', '~> 2.1', '>= 2.1.2'
gem 'underscore-rails', '~> 1.8', '>= 1.8.3'
gem 'devise', '~> 4.3'
gem 'figaro', '~> 1.1', '>= 1.1.1'
gem 'curb', '~> 0.9.3'
gem 'whois', '~> 4.0', '>= 4.0.4'
gem 'chartkick', '~> 2.2', '>= 2.2.4'

gem 'foreman', '~> 0.84.0'

## DEVELOPMENT & TEST GEMS BELOW => :development group, :test group
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

## DEVELOPMENT GEMS BELOW => :development group
group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '~> 3.5', '>= 3.5.1'
  gem 'listen', '~> 3.1', '>= 3.1.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
  # gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'rainbow', '~> 2.2', '>= 2.2.2'
  gem 'pry', '~> 0.10.4'

  gem 'sidekiq'
  gem 'sinatra', require: false
  gem 'slim'
  # gem 'thin', '~> 1.7'

  # Use Redis adapter to run Action Cable in production
  gem 'redis', '~> 3.3', '>= 3.3.1'

  # Use hirb for rails c table view.  Then in rails c:
  # require 'hirb'
  # Hirb.enable
  gem 'hirb'

  ## This is attempt to replace daemons for multiple workers.
  #gem 'delayed_job_worker_pool', '~> 0.2.3'
end
