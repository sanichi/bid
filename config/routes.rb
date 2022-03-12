Rails.application.routes.draw do
  root to: "pages#home"

  %w{env help home links}.each { |p| get p => "pages##{p}" }
  get "sign_in" => "sessions#new"

  resources :notes do
    get :modal, on: :member
  end
  resources :problems do
    get :review, on: :collection
    get :select, on: :collection
    get :retire, on: :collection
  end
  resources :users

  resource :session, only: [:new, :create, :destroy]
end
