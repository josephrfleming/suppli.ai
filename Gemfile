# frozen_string_literal: true
source "https://rubygems.org"

ruby "3.3.8"

########################################
# Core Rails stack
########################################
gem "rails", "~> 8.0.2"
gem "pg",           "~> 1.5"            # PostgreSQL adapter
gem "puma",         ">= 5.0"            # Web server
gem "propshaft"                         # Modern asset pipeline
gem "importmap-rails"                   # JS via ESM import maps
gem "turbo-rails"                       # Hotwire Turbo
gem "stimulus-rails"                    # Hotwire Stimulus
gem "jbuilder"                          # JSON view models
gem "solid_cache"                       # DB-backed cache
gem "solid_queue"                       # DB-backed Active Job (fallback)
gem "solid_cable"                       # DB-backed Action Cable (fallback)
gem "cssbundling-rails", "~> 1.3"

########################################
# Production-grade essentials
########################################
gem "devise"                            # Authentication
gem "pundit", "~> 2.3"                  # Authorization
gem "sidekiq"                           # Background jobs
gem "redis", "~> 4.0"                   # Sidekiq backend
gem "sidekiq-scheduler", require: false # Cron-style jobs
gem "view_component"                    # Re-usable view objects
gem "kaminari"                          # Pagination
gem "ruby-openai", "~> 8.1"             # OpenAI API client

########################################
# Quality-of-life & deployment
########################################
gem "dotenv-rails", groups: %i[development test]  # ENV management
gem "bootsnap",  require: false
gem "kamal",     require: false                   # Container deploy
gem "thruster",  require: false                   # HTTP accel

########################################
# Optional Active Storage processors
# gem "image_processing", "~> 1.12"
########################################

########################################
# Development & Test toolchain
########################################
group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "brakeman",          require: false          # Static security scan
  gem "rubocop-rails-omakase", require: false      # Code style
  gem "rspec-rails", "~> 6.1"                      # Test suite
  gem "factory_bot_rails"                          # Test factories
  gem "faker"                                      # Fake data
  gem "letter_opener", group: :development         # View mails in browser
end

group :development do
  gem "web-console"
  gem "annotate", require: false                   # Annotate models/routes
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "database_cleaner-active_record"
end

########################################
# Windows Zeitwerk fix
########################################
gem "tzinfo-data", platforms: %i[windows jruby]
