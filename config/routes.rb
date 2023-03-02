Rails.application.routes.draw do
  devise_for :users
  get "home/top"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root "posts#index"

  resources :posts, only: [:new, :create, :show, :destroy]

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
