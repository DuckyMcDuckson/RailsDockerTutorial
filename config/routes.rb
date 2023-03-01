Rails.application.routes.draw do
  devise_for :users
  get "home/top"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#top"

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
