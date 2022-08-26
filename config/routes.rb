Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'home_pages#home'
  get 'home_pages/questions'
  resources :freq_dictionaries, only: [:index]
  # Defines the root path route ("/")
  # root "articles#index"
end
