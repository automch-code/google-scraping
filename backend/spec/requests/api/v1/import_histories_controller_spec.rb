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

    context 'when search import_history' do
      before do
        FactoryBot.create(:import_history, filename: 'cat',user_id: user_1.id)
        FactoryBot.create(:import_history, filename: 'dog',user_id: user_1.id)
        FactoryBot.create(:import_history, filename: 'category',user_id: user_1.id)
      end

      it 'return 200 (ok)' do
        get '/api/v1/import_histories?query=cat', headers: headers_1

        expect(response).to have_http_status(:ok)
      end

      it 'return import_histories that contain "cat"' do
        get '/api/v1/import_histories?query=cat', headers: headers_1

        result = JSON.parse(response.body)
        expect(result["import_hisotry"].size).to eq(2)
      end
    end

    context 'when sort by created_at' do
      before do
        FactoryBot.create(:import_history, filename: 'cat',user_id: user_1.id)
        FactoryBot.create(:import_history, filename: 'dog',user_id: user_1.id)
        FactoryBot.create(:import_history, filename: 'category',user_id: user_1.id)
      end

      context 'with Descending (DESC)' do
        it 'return 200 (ok)' do
        get '/api/v1/import_histories?created_at=DESC', headers: headers_1

          expect(response).to have_http_status(:ok)
        end

        it 'return 3 import_histories with descending id' do
          get '/api/v1/import_histories?created_at=DESC', headers: headers_1

          result = JSON.parse(response.body)
          expect(result["import_hisotry"].size).to eq(3)
          expect(result["import_hisotry"].map{ _1["id"] }).to eq([3, 2, 1])
        end

        it 'return 3 import_histories with descending id' do
          get '/api/v1/import_histories?created_at=DESC', headers: headers_1

          result = JSON.parse(response.body)
          expect(result["import_hisotry"].size).to eq(3)
          expect(result["import_hisotry"].map{ _1["id"] }).to eq([3, 2, 1])
        end
      end

      context 'with Ascending (ASC)' do
        it 'return 200 (ok)' do
        get '/api/v1/import_histories?created_at=ASC', headers: headers_1

          expect(response).to have_http_status(:ok)
        end

        it 'return 3 import_histories with ascending id' do
          get '/api/v1/import_histories?created_at=ASC', headers: headers_1

          result = JSON.parse(response.body)
          expect(result["import_hisotry"].size).to eq(3)
          expect(result["import_hisotry"].map{ _1["id"] }).to eq([1, 2, 3])
        end

        it 'return 3 import_histories with ascending id' do
          get '/api/v1/import_histories?created_at=ASC', headers: headers_1

          result = JSON.parse(response.body)
          expect(result["import_hisotry"].size).to eq(3)
          expect(result["import_hisotry"].map{ _1["id"] }).to eq([1, 2, 3])
        end
      end
    end

    context 'when sort by updated_at' do
      before do
        FactoryBot.create(:import_history, filename: 'cat',user_id: user_1.id)
        FactoryBot.create(:import_history, filename: 'dog',user_id: user_1.id)
        FactoryBot.create(:import_history, filename: 'category',user_id: user_1.id)
      end

      context 'with Descending (DESC)' do
        it 'return 200 (ok)' do
          get '/api/v1/import_histories?updated=DESC', headers: headers_1

          expect(response).to have_http_status(:ok)
        end

        it 'return 3 import_histories with descending id' do
          get '/api/v1/import_histories?updated=DESC', headers: headers_1

          result = JSON.parse(response.body)
          expect(result["import_hisotry"].size).to eq(3)
          expect(result["import_hisotry"].map{ _1["id"] }).to eq([3, 2, 1])
        end
      end

      context 'with Ascending (ASC)' do
        it 'return 200 (ok)' do
          get '/api/v1/import_histories?updated_at=ASC', headers: headers_1

          expect(response).to have_http_status(:ok)
        end

        it 'return 3 import_histories with ascending id' do
          get '/api/v1/import_histories?updated_at=ASC', headers: headers_1

          result = JSON.parse(response.body)
          expect(result["import_hisotry"].size).to eq(3)
          expect(result["import_hisotry"].map{ _1["id"] }).to eq([1, 2, 3])
        end
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

    context 'when import more than 100 keywords' do
      let(:keywords_100_file)  { Rack::Test::UploadedFile.new(fixture_file_path('100_keywords.csv')) }

      it 'return 400 (bad_request)' do
        post '/api/v1/import_histories/upload', headers: headers_1, params: {
          import: {
            file: keywords_100_file
          }
        }

        expect(response).to have_http_status(:bad_request)
      end
      
      it 'return with message "The maximum number of keywords allowed per upload is 100."' do
        post '/api/v1/import_histories/upload', headers: headers_1, params: {
          import: {
            file: keywords_100_file
          }
        }

        result = JSON.parse(response.body)
        expect(result["message"]).to eq('The maximum number of keywords allowed per upload is 100.')
      end
    end
  end
end
