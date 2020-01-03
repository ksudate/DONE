Rails.application.routes.draw do
  root to: 'top_pages#home'
  get 'mypage', to: 'top_pages#mypage'
  post 'callback', to: 'line_bot#callback'
  delete 'line_logout', to: 'posts#line_logout'
  delete 'splints/delete_splint', to: 'splints#destroy_splint'
  resources :posts
  resources :splints do
    collection do
      get :analysis
      get :link
      get :export
      get :project_settings
    end
  end
end
