Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: "oauth_callbacks" }

  resources :files_attachment, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index
  resources :votes, only: %i[create destroy]
  resources :comments, only: :create
  resources :users, only: %i[edit update]

  resources :questions do
    resources :answers, shallow: true
    member do
      patch "mark_answer_as_best", to: "questions#mark_as_best"
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
      end

      resources :questions, only: :index
    end
  end

  root to: "questions#index"
  mount ActionCable.server => "/cable"
end
