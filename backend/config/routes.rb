Rails.application.routes.draw do

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  use_doorkeeper do
    skip_controllers :authorizations, :applications, :authorized_applications
    controllers tokens: 'api/v1/tokens'
  end
  
  namespace :api do
    namespace :v1 do
      devise_for :users, 
      skip: :sessions,
      controllers: { 
        passwords: 'api/v1/passwords',
        confirmations: 'api/v1/confirmations' 
      }

      resources :users do
        collection do
          post :registration
        end
      end

      resources :import_histories, only: %i[index] do
        collection do
          post :upload
        end
      end

      resources :keywords, only: %i[index show]
    end
  end
end
