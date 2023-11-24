source 'https://rubygems.org'

gem 'rails', '7.1.2'
gem 'haml-rails', '~> 2.0'
gem 'jquery-rails', '~> 4.3'
gem 'sassc-rails', '~> 2.1'
gem 'autoprefixer-rails', '~> 10.0'
gem 'bootstrap', '~> 5.0'
gem 'pg', '>= 0.18', '< 2.0'
gem 'bcrypt', '~> 3.1.7'
gem 'cancancan', '~> 3.0'
gem 'meta-tags', '~> 2.12'
gem 'redcarpet', '~> 3.5'
gem 'sprockets-rails', '~> 3.4'

group :development, :test do
  gem 'rspec-rails', '< 7'
  gem 'capybara', '~> 3.28'
  gem 'byebug', platforms: :mri
  gem 'launchy', '~> 2.5'
  gem 'factory_bot_rails', '~> 6.0'
  gem 'faker', '< 4'
  gem 'selenium-webdriver', '~> 4.0'
end

group :test do
  gem 'database_cleaner-active_record', '~> 2.0'
end

group :development do
  gem 'puma', '< 7'
  gem 'capistrano-rails', '~> 1.4', require: false
  gem 'capistrano-passenger', '~> 0.2', require: false
  gem 'listen', '~> 3.2'
end

group :production do
  gem 'terser', '~> 1.1'
end
