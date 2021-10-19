Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, shallow: true
    member do
      patch "mark_answer_as_best", to: "questions#mark_as_best"
    end
  end

  root to: "questions#index"
end
