source 'https://rubygems.org'
ruby '2.1.0'

gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'rails'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'therubyracer'
gem 'bcrypt-ruby'
gem 'bootstrap_form', :git => "git://github.com/bootstrap-ruby/rails-bootstrap-forms"
gem 'fabrication'
gem 'faker'
gem 'figaro'
gem 'sidekiq'
gem 'unicorn'

group :development do
  gem 'sqlite3'
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem "letter_opener"
end

group :test, :development do
  gem 'rspec-rails'
  gem 'pry'
  gem 'pry-nav'
end

group :test do
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'launchy'
  gem 'capybara-email'  
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

