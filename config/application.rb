require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Bookshare
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    require_relative Rails.root.join('lib/core_ext/string_ext')

    # Use sidekiq as job handler
    config.active_job.queue_adapter = :sidekiq

    # AMS config
    ActiveModelSerializers.config.adapter = :json
  end
end
