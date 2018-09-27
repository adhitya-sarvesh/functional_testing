# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# SMTP settings for the Action Mailer module
ActionMailer::Base.smtp_settings = {
  address: 'smtprr.cerner.com',
  port: 25,
  enable_starttls_auto: false
}
