source 'https://rubygems.org'

gem 'rails', '7.0.1'
gem 'haml-rails', '~> 2.0'
gem 'jquery-rails', '~> 4.3'
gem 'sassc-rails', '~> 2.1'
gem 'autoprefixer-rails', '~> 10.0'
gem 'bootstrap', '~> 5.0'
gem 'uglifier', '~> 4.2'
gem 'pg', '>= 0.18', '< 2.0'
gem 'bcrypt', '~> 3.1.7'
gem 'cancancan', '~> 3.0'
gem 'meta-tags', '~> 2.12'
gem 'redcarpet', '~> 3.5'
gem 'sprockets-rails', '~> 3.4'

group :development, :test do
  gem 'rspec-rails', '~> 5.0'
  gem 'capybara', '~> 3.28'
  gem 'byebug', platforms: :mri
  gem 'launchy', '~> 2.5'
  gem 'factory_bot_rails', '~> 6.0'
  gem 'faker', '~> 2.10'
  gem 'selenium-webdriver', '~> 3.142'
  gem 'rexml' # selenium needs this explicitly since ruby 3.0 (used to be a bundled gem)
end

group :test do
  gem 'database_cleaner-active_record', '~> 2.0'
end

group :development do
  gem 'puma', '~> 5.0'
  gem 'capistrano-rails', '~> 1.4', require: false
  gem 'capistrano-passenger', '~> 0.2', require: false
  gem 'listen', '~> 3.2'
end
