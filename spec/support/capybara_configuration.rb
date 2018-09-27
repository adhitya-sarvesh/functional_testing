require 'capybara/poltergeist'
require 'capybara/rspec'
require_relative '../../lib/scenario_builder'

TIMEOUT = 1000

RSpec.configure do |config|
  # Capybara configuration for poltergeist driver
  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(
      app,
      js_errors: false,
      timeout: TIMEOUT,
      phantomjs_options: ['--disk-cache=false', '--ignore-ssl-errors=yes', '--ssl-protocol=any']
    )
  end

  Capybara.configure do |config|
    config.default_driver = :poltergeist
    config.javascript_driver = :poltergeist
  end
  # Capybara configuration for poltergeist driver ends

  # Selenium web driver usage for development testing
  # Capybara.register_driver :selenium do |app|
  #   Capybara::Selenium::Driver.new(app, browser: :chrome)
  # end

  Capybara.configure do |config|
    config.run_server = false
    config.default_max_wait_time = TIMEOUT
    config.ignore_hidden_elements = false
  end

  # screenshot save path
  Capybara.save_path = "#{File.expand_path('../../../', __FILE__)}/public/images/capybara"

  config.include Capybara::DSL
  config.include Capybara::RSpecMatchers
  config.after do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
