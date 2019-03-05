Rails.application.routes.draw do
  resources :scrapers, except: [:new, :edit]
end
