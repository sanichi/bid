Rails.application.routes.draw do
  root to: "pages#home"

  %w{env help home}.each { |p| get p => "pages##{p}" }
  get "sign_in" => "sessions#new"

  resources :notes
  resources :problems
  resources :users

  resource :session, only: [:new, :create, :destroy]
end
