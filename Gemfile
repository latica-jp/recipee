source 'https://rubygems.org'

# Bundle edge Railsinstead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', group: :development
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Added 2016.01.14
gem 'honoka-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Recipe Note
gem 'jquery-ui-rails'
gem 'jquery-turbolinks'
gem 'slim-rails'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'sorcery' # for authentication
gem 'nokogiri' # for HTML parsing
gem 'carrierwave' # for image uploading
gem 'mini_magick', '3.8.0' # for image resizing
gem 'addressable' # for URL parsing used in recipe parser https://github.com/sporkmonger/addressable
gem 'holder_rails' # for generating placeholder image
gem 'cloudinary' # for image hosting on production
gem 'acts-as-taggable-on', '~> 3.4' # Tagging
gem 'ransack' # custom search
gem 'httparty' # call external api
gem 'acts_as_votable' # like / unlike
gem 'kaminari' # pagenate

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'pry-byebug'
  gem 'annotate' # schema 情報を model にコメントとして挿入してくれる
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :production do
  gem 'puma'
  gem 'rails_12factor'
  gem 'pg'
end
