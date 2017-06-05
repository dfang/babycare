# frozen_string_literal: true

require 'exception_notification/rails'

ExceptionNotification.configure do |config|
  # Ignore additional exception types.
  # ActiveRecord::RecordNotFound, Mongoid::Errors::DocumentNotFound, AbstractController::ActionNotFound and ActionController::RoutingError are already added.
  # config.ignored_exceptions += %w{ActionView::TemplateError CustomError}
  # don't ignore exceptions
  config.ignored_exceptions = []

  # Adds a condition to decide when an exception must be ignored or not.
  # The ignore_if method can be invoked multiple times to add extra conditions.
  # config.ignore_if do |exception, options|
  #   not Rails.env.production?
  # end

  # Notifiers =================================================================

  # Email notifier sends notifications by email.
  # config.add_notifier :email, email_prefix: '[ERROR](Call Me A Doctor)',
  #                             sender_address:        %("Notifier" <call_me_a_doctor@yhuan.cc>),
  #                             exception_recipients: %w[df1228@dingtalk.com],
  #                             smtp_settings: {
  #                               address:        'smtp.exmail.qq.com',
  #                               user_name:      'call_me_a_doctor@yhuan.cc',
  #                               password:       '1Qaz2wsx',
  #                               authentication: :login,
  #                               enable_starttls_auto: true
  #                             },
  #                             ignore_crawlers: %w[Googlebot bingbot AhrefsBot Baiduspider Site\ Scanner\ Bot Sogou HaosouSpider]

  config.add_notifier :slack, webhook_url: 'https://hooks.slack.com/services/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',
                              channel: '#exceptions',
                              username: 'exceptions_notifier',
                              ignore_exceptions: []

  # Campfire notifier sends notifications to your Campfire room. Requires 'tinder' gem.
  # config.add_notifier :campfire, {
  #   :subdomain => 'my_subdomain',
  #   :token => 'my_token',
  #   :room_name => 'my_room'
  # }

  # HipChat notifier sends notifications to your HipChat room. Requires 'hipchat' gem.
  # config.add_notifier :hipchat, {
  #   :api_token => 'my_token',
  #   :room_name => 'my_room'
  # }

  # Webhook notifier sends notifications over HTTP protocol. Requires 'httparty' gem.
  # config.add_notifier :webhook, {
  #   :url => 'http://example.com:5555/hubot/path',
  #   :http_method => :post
  # }
end
