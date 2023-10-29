require 'rails_helper'

RSpec.describe "Api::V1::ImportHistories", type: :request do
  let!(:application)    { FactoryBot.create(:application) }
  let!(:user_1)         { FactoryBot.create(:user) }
  let!(:token_1)        { FactoryBot.create(:access_token, application:, resource_owner_id: user_1.id) }
  let!(:headers_1)      { { Authorization: "Bearer #{token_1.token}" } }

  describe "GET /index" do
    context 'when import exists' do
      before { FactoryBot.create_list(:import_history, 2 ,user_id: user_1.id) }

      it 'return 200 (ok)' do
        get '/api/v1/import_histories', headers: headers_1

        expect(response).to have_http_status(:ok)
      end

      it 'return import_histories for user_1' do
        get '/api/v1/import_histories', headers: headers_1
        
        result = JSON.parse(response.body)
        expect(result["import_hisotry"].size).to eq(2)
      end
    end

    context 'when import not exists' do
      it 'return 200 (ok)' do
        get '/api/v1/import_histories', headers: headers_1

        expect(response).to have_http_status(:ok)
      end

      it 'return 0 import_histories for user_1' do
        get '/api/v1/import_histories', headers: headers_1
        
        result = JSON.parse(response.body)
        expect(result["import_hisotry"].size).to eq(0)
      end
    end
  end

  describe "POST /upload" do
    let(:csv_file)  { Rack::Test::UploadedFile.new(fixture_file_path('keywords_test.csv')) }

    context 'when import valid file (CSV)' do
      it 'return 202 (accepted)' do
        post '/api/v1/import_histories/upload', headers: headers_1, params: {
          import: {
            file: csv_file
          }
        }

        expect(response).to have_http_status(:accepted)
      end

      it 'return with message "Import %{filename} in processing..."' do
        post '/api/v1/import_histories/upload', headers: headers_1, params: {
          import: {
            file: csv_file
          }
        }

        result = JSON.parse(response.body)
        expect(result["message"]).to eq("Import '#{csv_file.original_filename}' in processing...")
      end
    end

    context 'when import is nil' do
      it 'return 400 (bad_request)' do
        post '/api/v1/import_histories/upload', headers: headers_1, params: {
          import: {
            file: nil
          }
        }

        expect(response).to have_http_status(:bad_request)
      end

      it 'return with message "File not found."' do
        post '/api/v1/import_histories/upload', headers: headers_1, params: {
          import: {
            file: nil
          }
        }

        result = JSON.parse(response.body)
        expect(result["message"]).to eq('File not found.')
      end
    end

    context 'when import invalid file' do
      let(:jpg_file)  { Rack::Test::UploadedFile.new(fixture_file_path('red-100x75.jpg')) }

      it 'return 400 (bad_request)' do
        post '/api/v1/import_histories/upload', headers: headers_1, params: {
          import: {
            file: jpg_file
          }
        }

        expect(response).to have_http_status(:bad_request)
      end

      it 'return with message "The file format is invalid. (use CSV)"' do
        post '/api/v1/import_histories/upload', headers: headers_1, params: {
          import: {
            file: jpg_file
          }
        }

        result = JSON.parse(response.body)
        expect(result["message"]).to eq('The file format is invalid. (use CSV)')
      end
    end
  end
end
