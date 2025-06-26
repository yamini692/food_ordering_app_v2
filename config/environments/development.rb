require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  # Reload application code on change
  config.enable_reloading = true

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable server timing
  config.server_timing = true


  # Enable/disable caching.
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system.
  config.active_storage.service = :local

  # MAILER CONFIGURATION FOR DEVISE (👇 Add this block)
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false


  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              "smtp.gmail.com",
    port:                 587,
    domain:               "gmail.com",
    user_name:            "yaminir791@gmail.com",
    password:             "llwo iltg ywki otgq ",
    authentication:       "plain",
    enable_starttls_auto: true
  }

  # Deprecation settings
  config.active_support.deprecation = :log
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []

  # Raise error on page load if migrations are pending.
  config.active_record.migration_error = :page_load

  # Highlight code in logs
  config.active_record.verbose_query_logs = true
  config.active_job.verbose_enqueue_logs = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Uncomment to allow Action Cable access from any origin.
  # config.action_cable.disable_request_forgery_protection = true

  # Raise error for missing only/except callback actions
  config.action_controller.raise_on_missing_callback_actions = true
end
