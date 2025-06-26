# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'

# Automatically require files in spec/support (optional, but useful)
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Ensure database schema is up to date
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # Use FactoryBot methods like create(:user)
  config.include FactoryBot::Syntax::Methods

  # Path to fixtures (if you use them)
  config.fixture_paths = [Rails.root.join('spec/fixtures')]

  # Run each test in a transaction
  config.use_transactional_fixtures = true

  # Automatically infer spec type from file location
  config.infer_spec_type_from_file_location!

  # Filter Rails gems from error backtraces
  config.filter_rails_from_backtrace!
end
