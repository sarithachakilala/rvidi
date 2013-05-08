OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, configatron.facebook_app_id, configatron.facebook_app_secret
  provider :twitter, configatron.twitter_consumer_key, configatron.twitter_consumer_secret
end

OmniAuth.config.on_failure = UsersController.action(:oauth_failure)