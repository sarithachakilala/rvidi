OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '443407499077841', '65b79a0b2eff0ec39376886d6a37a718'
  # provider :developer unless Rails.env.production?
  # provider :twitter, 'yC8k7ntNjfUBievtIRSt8w', 'PIiX7lOtcPYmZrAOEqKCY0Pz09swpa09SKmraGNQ'
end

OmniAuth.config.on_failure = UsersController.action(:oauth_failure)
