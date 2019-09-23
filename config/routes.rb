Rails.application.routes.draw do
  get 'posts/new'
  get 'posts/show'
  get 'top_pages/home'
  get 'posts/line_login', to: 'users#line_login'
end
