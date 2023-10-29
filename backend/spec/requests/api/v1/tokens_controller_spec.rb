require 'rails_helper'

RSpec.describe 'Api::V1::Tokens', type: :request do
  let!(:user)           { FactoryBot.create(:user) }
  let!(:application)    { FactoryBot.create(:application) }

  describe 'POST /create' do
    it 'should create access token successfully' do
      post oauth_token_path, params: {
        email: user.email,
        password: user.password,
        client_id: application.uid,
        client_secret: application.secret,
        grant_type: 'password'
      }

      result = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(result.keys).to eq(%w[access_token token_type expires_in refresh_token created_at user])
      jwt = JWT.decode(result['user'], ENV['JWT_SECRET_KEY'], 'HS256')[0]
      expect(jwt['email']).to eq(user.email)
      expect(jwt['role']).to eq('admin')
    end

    it 'should not create access token when user not confirmed' do
      user.update(confirmed_at: nil)

      post '/oauth/token', params: {
        email: user.email,
        password: user.password,
        client_id: application.uid,
        client_secret: application.secret,
        grant_type: 'password'
      }
      expect(response.status).to eq(400)
      expect(JSON.parse(response.body)['error_description']).to eq(
        'The provided authorization grant is invalid, expired, revoked, ' \
        'does not match the redirection URI used in the authorization request, or was issued to another client.'
      )
    end

    it 'should not create access token when invalid email' do
      post '/oauth/token', params: {
        email: 'user.email',
        password: user.password,
        client_id: application.uid,
        client_secret: application.secret,
        grant_type: 'password'
      }
      expect(response.status).to eq(400)
      expect(JSON.parse(response.body)['error']).to eq('invalid_grant')
      expect(JSON.parse(response.body)['error_description']).to eq(
        'The provided authorization grant is invalid, expired, revoked, ' \
        'does not match the redirection URI used in the authorization request, or was issued to another client.'
      )
    end

    it 'should not create access token when invalid password' do
      post '/oauth/token', params: {
        email: user.email,
        password: 'user.password',
        client_id: application.uid,
        client_secret: application.secret,
        grant_type: 'password'
      }
      expect(response.status).to eq(400)
      expect(JSON.parse(response.body)['error']).to eq('invalid_grant')
      expect(JSON.parse(response.body)['error_description']).to eq(
        'The provided authorization grant is invalid, expired, revoked, ' \
        'does not match the redirection URI used in the authorization request, or was issued to another client.'
      )
    end

    it 'should not create access token when invalid client_id' do
      post '/oauth/token', params: {
        email: user.email,
        password: user.password,
        client_id: 'application.uid',
        client_secret: application.secret,
        grant_type: 'password'
      }
      expect(response.status).to eq(401)
      expect(JSON.parse(response.body)['error']).to eq('invalid_client')
    end

    it 'should not create access token when invalid client_secret' do
      post '/oauth/token', params: {
        email: user.email,
        password: user.password,
        client_id: application.uid,
        client_secret: 'application.secret',
        grant_type: 'password'
      }
      expect(response.status).to eq(401)
      expect(JSON.parse(response.body)['error']).to eq('invalid_client')
    end

    it 'should not create access token when invalid grant_type' do
      post '/oauth/token', params: {
        email: user.email,
        password: user.password,
        client_id: application.uid,
        client_secret: application.secret,
        grant_type: 'passwords'
      }
      expect(response.status).to eq(400)
      expect(JSON.parse(response.body)['error']).to eq('unsupported_grant_type')
    end
  end
end
