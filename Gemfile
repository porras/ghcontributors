source 'https://rubygems.org'

gem 'sinatra'
gem 'couchrest', :git => 'git://github.com/couchrest/couchrest.git'
gem 'octokit', :git => 'git://github.com/pengwynn/octokit.git'
gem 'rake'
gem 'nokogiri'

group :production do
  gem 'foreman'
  gem 'thin'
end

group :test do
  gem 'capybara'
  gem 'webmock'
end

group :development do
  gem 'shotgun'
  gem 'launchy'
end