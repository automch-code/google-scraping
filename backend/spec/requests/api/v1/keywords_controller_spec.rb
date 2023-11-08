require 'rails_helper'

RSpec.describe "Api::V1::Keywords", type: :request do
  let!(:application)    { FactoryBot.create(:application) }
  let!(:user_1)         { FactoryBot.create(:user) }
  let!(:token_1)        { FactoryBot.create(:access_token, application:, resource_owner_id: user_1.id) }
  let!(:headers_1)      { { Authorization: "Bearer #{token_1.token}" } }
  let!(:user_2)         { FactoryBot.create(:user) }
  let!(:token_2)        { FactoryBot.create(:access_token, application:, resource_owner_id: user_2.id) }
  let!(:headers_2)      { { Authorization: "Bearer #{token_2.token}" } }

  describe "GET /index" do
    context 'when keywords exist' do
      before do 
        FactoryBot.create_list(:keyword, 2 ,user_id: user_1.id)
        FactoryBot.create_list(:keyword, 5 ,user_id: user_2.id)
      end

      it 'return 200 (ok)' do
        get '/api/v1/keywords', headers: headers_1

        expect(response).to have_http_status(:ok)
      end

      it 'return 2 keywords for user_1' do
        get '/api/v1/keywords', headers: headers_1
        
        result = JSON.parse(response.body)
        expect(result["keywords"].size).to eq(2)
      end

      it 'return 5 keywords for user_2' do
        get '/api/v1/keywords', headers: headers_2
        
        result = JSON.parse(response.body)
        expect(result["keywords"].size).to eq(5)
      end
    end

    context 'when keywords not exist' do
      it 'return 200 (ok)' do
        get '/api/v1/keywords', headers: headers_1

        expect(response).to have_http_status(:ok)
      end

      it 'return empty keywords for user_1' do
        get '/api/v1/keywords', headers: headers_1
        
        result = JSON.parse(response.body)
        expect(result["keywords"].size).to eq(0)
      end
    end

    context 'when search keyword' do
      before do
        FactoryBot.create(:keyword, word: 'cat',user_id: user_1.id)
        FactoryBot.create(:keyword, word: 'dog',user_id: user_1.id)
        FactoryBot.create(:keyword, word: 'category',user_id: user_1.id)
      end

      it 'return 200 (ok)' do
        get '/api/v1/keywords?query=cat', headers: headers_1

        expect(response).to have_http_status(:ok)
      end

      it 'return keywords that contain "cat"' do
        get '/api/v1/keywords?query=cat', headers: headers_1

        result = JSON.parse(response.body)
        expect(result["keywords"].size).to eq(2)
      end
    end

    context 'when sort by created_at' do
      before do
        FactoryBot.create(:keyword, word: 'cat',user_id: user_1.id)
        FactoryBot.create(:keyword, word: 'dog',user_id: user_1.id)
        FactoryBot.create(:keyword, word: 'category',user_id: user_1.id)
      end

      context 'with Descending (DESC)' do
        it 'return 200 (ok)' do
        get '/api/v1/keywords?created_at=DESC', headers: headers_1

          expect(response).to have_http_status(:ok)
        end

        it 'return 3 keywords with descending id' do
          get '/api/v1/keywords?created_at=DESC', headers: headers_1

          result = JSON.parse(response.body)
          expect(result["keywords"].size).to eq(3)
          expect(result["keywords"].map{ _1["id"] }).to eq([3, 2, 1])
        end

        it 'return 3 keywords with descending id' do
          get '/api/v1/keywords?created_at=DESC', headers: headers_1

          result = JSON.parse(response.body)
          expect(result["keywords"].size).to eq(3)
          expect(result["keywords"].map{ _1["id"] }).to eq([3, 2, 1])
        end
      end

      context 'with Ascending (ASC)' do
        it 'return 200 (ok)' do
        get '/api/v1/keywords?created_at=ASC', headers: headers_1

          expect(response).to have_http_status(:ok)
        end

        it 'return 3 keywords with ascending id' do
          get '/api/v1/keywords?created_at=ASC', headers: headers_1

          result = JSON.parse(response.body)
          expect(result["keywords"].size).to eq(3)
          expect(result["keywords"].map{ _1["id"] }).to eq([1, 2, 3])
        end

        it 'return 3 keywords with ascending id' do
          get '/api/v1/keywords?created_at=ASC', headers: headers_1

          result = JSON.parse(response.body)
          expect(result["keywords"].size).to eq(3)
          expect(result["keywords"].map{ _1["id"] }).to eq([1, 2, 3])
        end
      end
    end

    context 'when sort by updated_at' do
      before do
        FactoryBot.create(:keyword, word: 'cat',user_id: user_1.id)
        FactoryBot.create(:keyword, word: 'dog',user_id: user_1.id)
        FactoryBot.create(:keyword, word: 'category',user_id: user_1.id)
      end

      context 'with Descending (DESC)' do
        it 'return 200 (ok)' do
          get '/api/v1/keywords?updated=DESC', headers: headers_1

          expect(response).to have_http_status(:ok)
        end

        it 'return 3 keywords with descending id' do
          get '/api/v1/keywords?updated=DESC', headers: headers_1

          result = JSON.parse(response.body)
          expect(result["keywords"].size).to eq(3)
          expect(result["keywords"].map{ _1["id"] }).to eq([3, 2, 1])
        end
      end

      context 'with Ascending (ASC)' do
        it 'return 200 (ok)' do
          get '/api/v1/keywords?updated_at=ASC', headers: headers_1

          expect(response).to have_http_status(:ok)
        end

        it 'return 3 keywords with ascending id' do
          get '/api/v1/keywords?updated_at=ASC', headers: headers_1

          result = JSON.parse(response.body)
          expect(result["keywords"].size).to eq(3)
          expect(result["keywords"].map{ _1["id"] }).to eq([1, 2, 3])
        end
      end
    end
  end

  describe "GET /show" do
    context 'when keyword exist' do
      let!(:cat)                  { FactoryBot.create(:keyword, word: 'cat', links: 5, user_id: user_1.id) }

      it 'return 200 (ok)' do
        get "/api/v1/keywords/#{cat.id}", headers: headers_1

        expect(response).to have_http_status(:ok)
      end

      it 'return keyword "cat" for user_1' do
        get "/api/v1/keywords/#{cat.id}", headers: headers_1
        
        result = JSON.parse(response.body)
        expect(result["keyword"]["id"]).to eq(1)
        expect(result["keyword"]["word"]).to eq('cat')
        expect(result["keyword"]["user_id"]).to eq(user_1.id)
      end
    end

    context 'when keywords not exist' do
      it 'return 404 (not found)' do
        get '/api/v1/keywords/1', headers: headers_1
        
        result = JSON.parse(response.body)
        expect(response).to have_http_status(:not_found)
        expect(result["message"]).to eq('Not found.')
      end
    end

    context 'when user_1 search keyword of user_2' do
      let!(:cat)                  { FactoryBot.create(:keyword, word: 'cat', links: 5, user_id: user_1.id) }
      let!(:dog)                  { FactoryBot.create(:keyword, word: 'dog', links: 12, user_id: user_2.id) }

      it 'return 404 (not found)' do
        get "/api/v1/keywords/#{dog.id}", headers: headers_1

        result = JSON.parse(response.body)
        expect(response).to have_http_status(:not_found)
        expect(result["message"]).to eq('Not found.')
      end
    end
  end
end
