Rails.application.routes.draw do
  get '/auth/remotty/callback' => 'remotty_rails/sessions#create', :as => :create_session
  get '/signin' => 'remotty_rails/sessions#new', :as => :signin
  get '/signout' => 'remotty_rails/sessions#destroy', :as => :signout
  get '/auth/failure' => 'remotty_rails/sessions#failure', :as => :failure
end
