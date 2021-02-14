Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :partners, only: [:show]
      get 'partners/match/:customer_request_id', to: 'partners#index'
    end
  end
end
