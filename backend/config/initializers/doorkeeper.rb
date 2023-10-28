# frozen_string_literal: true

Doorkeeper.configure do
  # Change the ORM that doorkeeper will use (requires ORM extensions installed).
  # Check the list of supported ORMs here: https://github.com/doorkeeper-gem/doorkeeper#orms
  orm :active_record
  
  use_polymorphic_resource_owner

  resource_owner_from_credentials do |_routes|
    User.authenticate(params[:email], params[:password])
  end

  access_token_expires_in 10.minutes
  
  use_refresh_token

  allow_blank_redirect_uri true
  
  grant_flows %w[password]

  skip_authorization do |resource_owner, client|
    true
  end
end
