require_relative 'boot'
require 'csv'
require 'rails/all'
# require 'pry'
# require 'rainbow'

### ORIGINAL SETTINGS: Require the gems listed in Gemfile, including any gems you've limited to :test, :development, or :production.
# Bundler.require(*Rails.groups)

### ADAM SETTINGS: ONLY REQUIRE THE PRODUCTION GEMS:
Bundler.require(:default, Rails.env)

module Bigdatasage
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths << File.join(config.root, "lib")
    config.autoload_paths += %W(#{config.root}/controllers/concerns)
    # config.autoload_paths += %W(#{config.root}/lib/servicers)
    config.autoload_paths << Rails.root.join('lib/servicers')
    config.autoload_paths += Dir["#{config.root}/lib/servicers"]

    ## 8/10/16 Added this for Delayed Job, per blog.
    # Do not swallow errors in after_commit/after_rollback callbacks.
    # config.active_record.raise_in_transactional_callbacks = true
    # config.active_job.queue_adapter = :sidekiq
    # config.active_job.queue_adapter = :delayed_job
  end
end
