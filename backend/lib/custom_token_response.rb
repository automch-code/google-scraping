module CustomTokenResponse
  def body
    @user = @token.resource_owner
    role = @user.role

    additional_data = {
      email: @user.email,
      role: role
    }

    super.merge(user: JWT.encode(additional_data, ENV['JWT_SECRET_KEY'], 'HS256'))
  end
end