source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.2.8.1'
# Use postgresql as the database
gem "pg", '~> 1.3.5'
# Use Puma as the app server
gem 'puma', '~> 5.6'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.1.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'nokogiri', '~>1.14.2'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5.2.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.5.0'
# Limit redlock version < 2.0 because of failures in sidekiq jobs. See https://github.com/samvera/hyrax/pull/5961
gem 'redlock', '>= 0.1.2', '< 2.0'
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'rsolr', '~> 2.5.0'
gem 'bootstrap-sass', '~> 3.4.1'
gem 'twitter-typeahead-rails', '0.11.1.pre.corejavascript'
gem 'jquery-rails', '~> 4.5.0'
gem 'devise-guests', '~> 0.6'
gem 'devise', '~> 4.8.0'
gem 'riiif', '~> 2.4.0'
gem 'blacklight_advanced_search', '~> 6.4.1'
gem 'business', '~> 2.3'
gem 'dotenv-rails'
gem 'httparty', '~> 0.21.0'
gem 'hydra-role-management', '~> 1.2'
gem 'jquery-ui-rails', '~> 6.0'
gem 'nilify_blanks', '~> 1.4'
gem 'omniauth-saml', '~> 2.1'
gem 'omniauth-rails_csrf_protection', '1.0.1'
gem 'mini_magick', '~>4.11.0'
# Use sidekiq and whenever for background jobs
gem 'sidekiq', '~> 6.5'
gem 'sidekiq-status', '~> 3.0.0'
gem 'sidekiq-client-cli'
gem 'whenever', '~> 1.0'
gem 'sidekiq-failures', '~> 1.0', '>= 1.0.4'
# Use Rails-LaTeX to generate PDFs
gem 'rails-latex','~> 2.3', '>= 2.3.4'
gem 'hyrax', '3.6.0'
gem "bulkrax", '5.5.0'
gem 'active-fedora', '~> 13.1'
gem 'dry-monads', '1.4.0'
gem 'psych', '< 4'
gem 'okcomputer'
gem 'http', '5.1.0'
gem 'llhttp-ffi', '0.4.0' # 0.5.0 is broken for x86_darwin architecture

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 3.36'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
  gem 'rspec-rails', "~> 5.1.2"
  gem 'shoulda-matchers'
  gem 'solr_wrapper', '>= 4.0.2'
  gem 'fcrepo_wrapper'
  gem 'sprockets', '3.7.2'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.7.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'debase', '~> 0.2.4.1'
end