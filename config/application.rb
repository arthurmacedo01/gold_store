require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GoldStore
  class Application < Rails::Application
    # Set default locale to Brazilian Portuguese
    config.i18n.default_locale = :'pt-BR'
    config.time_zone = "Brasilia"
    config.active_job.queue_adapter = :sidekiq

    if defined?(FactoryBotRails)
      initializer after: "factory_bot.set_factory_paths" do
        require "spree/testing_support/factory_bot"

        # The paths for Solidus' core factories.
        solidus_paths = Spree::TestingSupport::FactoryBot.definition_file_paths

        # Optional: Any factories you want to require from extensions.
        extension_paths = [
          # MySolidusExtension::Engine.root.join("lib/my_solidus_extension/testing_support/factories"),
          # or individually:
          # MySolidusExtension::Engine.root.join("lib/my_solidus_extension/testing_support/factories/resource.rb"),
        ]

        # Your application's own factories.
        app_paths = [
          Rails.root.join("spec/factories")
        ]

        FactoryBot.definition_file_paths = solidus_paths + extension_paths + app_paths
      end
    end
    # Initialize configuration defaults for originally generated Rails version.
    # config.load_defaults 7.2
    config.load_defaults 7.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.eager_load_paths << Rails.root.join("app/models").to_s
  end
end
