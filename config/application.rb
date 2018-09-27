require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
ENV.update YAML.load_file('config/application.yml')[Rails.env] rescue {}

module ACID
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.app_generators.stylesheet_engine :less
    config.autoload_paths << Rails.root.join('lib')

    # The default locale is :en and all translations from
    # config/locales/*.rb,yml and any subdirectories are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}').to_s]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**/*.{rb,yml}').to_s]

    # If we request a locale that doesn't have a corresponding file, use the default instead of throwing an error
    config.i18n.enforce_available_locales = false
    config.i18n.available_locales = %w(en)
    config.i18n.default_locale = 'en'
    config.i18n.fallbacks = ['en']

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = 'utf-8'
  end
end
