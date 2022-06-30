Rails.application.routes.draw do
  resources :transactions, only: %i[create]
end
