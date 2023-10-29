require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  describe 'POST /registration' do
    context 'when valid params' do
      it 'return 201 (created)' do
        post registration_api_v1_users_path, params: {
          user: {
            email: 'test@example.com',
            password: 'testtest',
            password_confirmation: 'testtest'
          }
        }
        expect(response).to have_http_status(:created)
      end

      it 'return correct email' do
        post registration_api_v1_users_path, params: {
          user: {
            email: 'test@example.com',
            password: 'testtest',
            password_confirmation: 'testtest'
          }
        }
        result = JSON.parse(response.body)
        expect(result['user']['email']).to eq('test@example.com')
      end

      it 'default sign up with role "user"' do
        post registration_api_v1_users_path, params: {
          user: {
            email: 'test@example.com',
            password: 'testtest',
            password_confirmation: 'testtest'
          }
        }
        result = JSON.parse(response.body)
        expect(result['user']['role']).to eq('user')
      end
    end

    context 'when email is empty' do
      it 'return 400 (bad_request)' do
        post registration_api_v1_users_path, params: {
          user: {
            email: '',
            password: 'password',
            password_confirmation: 'password'
          }
        }
        expect(response).to have_http_status(:bad_request)
      end

      it 'return error message "Email can\'t be blank, Email is invalid"' do
        post registration_api_v1_users_path, params: {
          user: {
            email: '',
            password: 'password',
            password_confirmation: 'password'
          }
        }
        result = JSON.parse(response.body)
        expect(result["message"]).to eq("Email can't be blank, Email is invalid")
      end
    end

    context 'when email has wrong format' do
      it 'return 400 (bad_request)' do
        post registration_api_v1_users_path, params: {
          user: {
            email: 'testtest',
            password: 'password',
            password_confirmation: 'password'
          }
        }
        expect(response).to have_http_status(:bad_request)
      end

      it 'return error message "Email is invalid"' do
        post registration_api_v1_users_path, params: {
          user: {
            email: 'testtest',
            password: 'password',
            password_confirmation: 'password'
          }
        }
        result = JSON.parse(response.body)
        expect(result["message"]).to eq("Email is invalid")
      end
    end

    context 'when password is empty' do
      it 'return 400 (bad_request)' do
        post registration_api_v1_users_path, params: {
          user: {
            email: 'test@example.com',
            password: '',
            password_confirmation: ''
          }
        }
        expect(response).to have_http_status(:bad_request)
      end

      it 'return error message "Password can\'t be blank"' do
        post registration_api_v1_users_path, params: {
          user: {
            email: 'test@example.com',
            password: '',
            password_confirmation: ''
          }
        }
        result = JSON.parse(response.body)
        expect(result["message"]).to eq("Password can't be blank")
      end
    end

    context 'when password not match with password_confirmation' do
      it 'return 400 (bad_request)' do
        post registration_api_v1_users_path, params: {
          user: {
            email: 'test@example.com',
            password: 'password',
            password_confirmation: ''
          }
        }
        expect(response).to have_http_status(:bad_request)
      end

      it 'return error message "Password confirmation doesn\'t match Password"' do
        post registration_api_v1_users_path, params: {
          user: {
            email: 'test@example.com',
            password: 'password',
            password_confirmation: ''
          }
        }
        result = JSON.parse(response.body)
        expect(result["message"]).to eq("Password confirmation doesn't match Password")
      end
    end

    context 'when password longer than 128 characters' do
      it 'return 400 (bad_request)' do
        post registration_api_v1_users_path, params: {
          user: {
            email: 'test@example.com',
            password: 't'*129,
            password_confirmation: 't'*129
          }
        }
        expect(response).to have_http_status(:bad_request)
      end

      it 'return error message "Password is too long (maximum is 128 characters)"' do
        post registration_api_v1_users_path, params: {
          user: {
            email: 'test@example.com',
            password: 't'*129,
            password_confirmation: 't'*129
          }
        }
        result = JSON.parse(response.body)
        expect(result["message"]).to eq("Password is too long (maximum is 128 characters)")
      end
    end

    context 'when password shorter than 6 characters' do
      it 'return 400 (bad_request)' do
        post registration_api_v1_users_path, params: {
          user: {
            email: 'test@example.com',
            password: 't'*129,
            password_confirmation: 't'
          }
        }
        expect(response).to have_http_status(:bad_request)
      end

      it 'return error message "Password is too short (minimum is 6 characters)"' do
        post registration_api_v1_users_path, params: {
          user: {
            email: 'test@example.com',
            password: 't',
            password_confirmation: 't'
          }
        }
        result = JSON.parse(response.body)
        expect(result["message"]).to eq("Password is too short (minimum is 6 characters)")
      end
    end
  end
end
