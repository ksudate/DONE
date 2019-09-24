Rails.application.routes.draw do
  post 'callback', to: 'line_bot#callback'
  resources :posts
  get '/', to: 'top_pages#home'
end
