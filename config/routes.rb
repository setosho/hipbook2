Rails.application.routes.draw do
  resources :sessions, only: [:new, :create, :destroy]

  resources :favorites, only: [:create, :destroy]

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  resources :users do
    member do
      get :favorite_picture
    end
  end

  resources :feeds do
    collection do
      post :confirm
    end
  end
end
