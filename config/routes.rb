Rails.application.routes.draw do
  devise_for :users
  get "home/top"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root "home#top"

  resources :posts, only: [:new, :create, :show]

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
