source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.1'

gem 'rails', '5.2.2.1'
# Use Puma as the app server
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

gem 'sdoc', '~> 0.4.0',          group: :doc


gem 'devise'
gem 'pg'
gem 'cancancan', '~> 1.10'
gem 'ruby-ip'
gem 'ransack'
gem 'rails-i18n'
gem 'devise-i18n'
gem 'kaminari-i18n'
gem 'rails4-autocomplete'
gem 'jquery-ui-rails'
gem 'whenever', :require => false

gem 'momentjs-rails', '>= 2.9.0'
#gem 'bootstrap-sass'
#gem 'bootstrap3-datetimepicker-rails', '~> 4.14.30'
#gem 'kaminari-bootstrap', '~> 3.0.1'
gem 'kaminari'
gem 'bootstrap4-kaminari-views'
gem 'bootstrap4-datetime-picker-rails'
gem 'bootstrap', '~> 4.3.1'

group :assets do
  gem 'execjs'
  #gem 'therubyracer', platform: :ruby
end

#gem 'delayed_job_active_record'
#gem "delayed_job_web"
#gem 'net-ssh-simple',   '~> 1.1.1'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_21]
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  #gem 'quiet_assets'
  gem 'rails_layout'
  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development, :test do
  # gem 'factory_girl_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'thin'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver'
end
