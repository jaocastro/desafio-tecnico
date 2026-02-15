Rails.application.routes.draw do
  post "auth/login", to: "auth#login"
  get  "auth/me",    to: "auth#me"

  resources :jobs

  get "up" => "rails/health#show", as: :rails_health_check
end
