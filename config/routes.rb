Rails.application.routes.draw do
  root to: 'top_pages#home'
  post 'callback', to: 'line_bot#callback'
  resources :posts do
    collection do
      delete :line_logout
    end
  end
  resources :splints do
    collection do
      get :analysis
      get :link
      get :export
      get :project_settings
      delete :delete_splint
    end
  end
  resources :rooms do
    resource :members, only: [:create, :destroy]
  end
end
