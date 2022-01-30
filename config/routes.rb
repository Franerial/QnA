Rails.application.routes.draw do
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

  root to: "questions#index"
  mount ActionCable.server => "/cable"
end
