Rails.application.routes.draw do
  devise_for :users

  resources :files_attachment, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index
  resources :votes, only: %i[create destroy]
  resources :comments, only: :create

  resources :questions do
    resources :answers, shallow: true
    member do
      patch "mark_answer_as_best", to: "questions#mark_as_best"
    end
  end

  root to: "questions#index"
  mount ActionCable.server => "/cable"
end
