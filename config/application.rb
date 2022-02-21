# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module InstaClone
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # generateコマンド時に生成されるファイルを制限する
    config.generators do |g|
      g.skip_routes true
      g.assets false
      g.helper false
      g.test_framework false
    end
    # タイムゾーン
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local

    # i18の基本設定
    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]

    # Railsとsidekiqを連携させるための追記
    config.active_job.queue_adapter = :sidekiq
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
