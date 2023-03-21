source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'
gem 'rails', '~> 6.1.7', '>= 6.1.7.3'
gem 'postgresql'
gem 'puma', '~> 5.0'

gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'dotenv-rails'
gem 'jwt', '~> 2.2'
gem 'kaminari'
gem 'nokogiri'
gem 'rack-cors', '~> 1.1', '>= 1.1.1'
gem 'redis'
gem 'selenium-webdriver'
gem 'sidekiq'
gem 'simple_command', '~> 0.1.0'
gem 'webdrivers', '~> 5.0'
gem 'versionist'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'spring'
end

group :test do
  gem 'database_cleaner-active_record'
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'timecop'
  gem 'faker'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
