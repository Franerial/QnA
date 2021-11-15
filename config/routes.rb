Rails.application.routes.draw do
  devise_for :users

  #delete "delete_file_attachment/:id", to: "files_attachment_controller#delete_file_attachment"
  resources :files_attachment, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index

  resources :questions do
    resources :answers, shallow: true
    member do
      patch "mark_answer_as_best", to: "questions#mark_as_best"
    end
  end

  root to: "questions#index"
end
