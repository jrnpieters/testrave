### big rave party
require 'rubygems'
require 'capybara/cucumber'
require 'headless'
require 'capybara-webkit'
require 'selenium-webdriver'
require 'rspec'

#headless = Headless.new
#headless.start

Capybara.default_driver = :webkit

Capybara::Webkit.configure do |config|
config.allow_unknown_urls
end

#headless.destroy
