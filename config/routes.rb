Rails.application.routes.draw do
  resources :users, only: [:new, :create]

  resources :feeds do
    collection do
      post :confirm
    end
  end
end
