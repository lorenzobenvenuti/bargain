Rails.application.routes.draw do
  resources :scrapers, except: [:new, :edit] do
    member do
      get 'test'
    end
  end

  resources :items, except: [:new, :edit] do
    member do
      get 'price'
    end
  end
end
