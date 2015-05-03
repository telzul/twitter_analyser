source 'https://rubygems.org'

#Core
gem 'rails', '4.2.0'
gem 'spring',        group: :development
gem 'sdoc', '~> 0.4.0', group: :doc

#Assets
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'bootstrap-sass'
gem 'font-awesome-rails'
gem 'haml-rails'

gem 'sinatra', :require => nil


gem 'sidekiq'

gem 'disqus_api'
gem 'open4'
gem 'figaro'

# Sentiment Analysis
gem 'tokenizer'

# Deploy
group :development do
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-passenger'
  gem 'capistrano-sidekiq'
end


group :development, :test do
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'rspec-rails'
end

group :test do
  gem 'database_cleaner'
end