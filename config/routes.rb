Rails.application.routes.draw do
  get "/jzproject", to: 'jzproject#newgrab'
  post "/jzproject", to: 'jzproject#newgrab#dograb'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
