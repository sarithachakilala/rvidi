OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '443407499077841', '65b79a0b2eff0ec39376886d6a37a718'
end

OmniAuth.config.on_failure = UsersController.action(:oauth_failure)