Rails.application.routes.draw do
  resources :scrapers, except: [:new, :edit] do
    member do
      get 'test'
    end
  end
end
