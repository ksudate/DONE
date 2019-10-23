Rails.application.routes.draw do
  get '/', to: 'top_pages#home'
  get '/logout', to: 'top_pages#logout'
  post 'callback', to: 'line_bot#callback'
  resources :posts
end
