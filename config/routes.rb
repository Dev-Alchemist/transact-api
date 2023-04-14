Rails.application.routes.draw do
  devise_for :users,
    controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations"
    },
    defaults: {format: :json}

  resources :topups, only: [:new, :create]
  resources :transactions, only: [:index, :create]
  resources :topups, only: [] do
    post :charge, on: :collection
    post :stk_result, on: :collection
  end
end
