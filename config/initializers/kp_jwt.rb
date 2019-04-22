# frozen_string_literal: true

# Use this hook to configure KpJwt
KpJwt.setup do |config|
  # Expiration claim
  # by default it is set to 1 day
  # config.token_lifetime = 1.day

  # Audience claim
  # by default it is set to nil
  # config.token_audience = nil

  # Signature algorithm
  # by default it is set to 'HS256'
  # config.token_signature_algorithm = 'HS256'

  # Signature key
  # by default it is set to -> { Rails.application.secrets.secret_key_base }
  # config.token_secret_signature_key = -> { Rails.application.secrets.secret_key_base }

  # Refresh Token Required
  # by default it is set to true
  # config.refresh_token_required = true

  # Refresh Token Lifetime
  # by default it is set to nil
  # config.refresh_token_lifetime = 1.week

  # Exception Class
  # by default it is set to 'ActiveRecord::RecordNotFound'
  # config.not_found_exception_class_name = 'ActiveRecord::RecordNotFound'
end
