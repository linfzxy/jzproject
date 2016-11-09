Rails.application.routes.draw do
  get "/jzproject", to: 'jzproject#newgrab'
  post "/jzproject", to: 'jzproject#dograb'
  get "/jzproject/checkstage", to: 'jzproject#checkstage'
  get "/jzproject/analysis", to: 'jzproject#analysis'
  get "/jzproject/makexlsx", to: 'jzproject#makexlsx'
  get "/jzproject/reset", to: 'jzproject#reset'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
