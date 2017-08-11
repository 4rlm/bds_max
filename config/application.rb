require_relative 'boot'
require 'csv'
require 'rails/all'
require 'pry'
require 'rainbow'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Bigdatasage
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths << File.join(config.root, "lib")

    config.autoload_paths += %W(#{config.root}/controllers/concerns)

    ## 8/10/16 Added this for Delayed Job, per blog.
    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    config.active_job.queue_adapter = :delayed_job
  end
end
