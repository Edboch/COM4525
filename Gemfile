# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '>= 7.0.8.1'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 6.0'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

gem 'activerecord-session_store'
gem 'bootstrap_form'
gem 'hamlit'
gem 'hamlit-rails'
gem 'rspec-benchmark'
gem 'simple_form'

gem 'draper'

gem 'shakapacker'

gem 'cancancan'
gem 'devise'

gem 'daemons'
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'whenever'

gem 'sanitize_email'

gem 'rubocop', require: false
gem 'rubocop-capybara', require: false
gem 'rubocop-factory_bot', require: false
gem 'rubocop-haml', require: false
gem 'rubocop-rails', require: false
gem 'rubocop-rspec', require: false

gem 'sentry-rails'
gem 'sentry-ruby'

gem 'rack', '>= 3.0.9.1'
gem 'stringio', '>= 3.0.1.1'

# for scraping
gem 'httparty'
gem 'nokogiri'

group :development do
  gem 'annotate'
  gem 'brakeman'
  gem 'bundler-audit'
  gem 'letter_opener'

  gem 'capistrano'
  gem 'capistrano-bundler', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false

  gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'
  gem 'ed25519', '>= 1.2', '< 2.0'
  gem 'epi_deploy', git: 'https://github.com/epigenesys/epi_deploy.git'

  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'simplecov'
  gem 'webmock'
end

group :development, :test do
  gem 'factory_bot_rails'
  gem 'rspec-rails'

  gem 'faker'

  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end
