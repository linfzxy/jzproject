Rails.application.routes.draw do
  get "/jzproject", to: 'jzproject#newgrab'
  post "/jzproject", to: 'jzproject#dograb'
  get "/jzproject/checkstage", to: 'jzproject#checkstage'
  get "/jzproject/analysis", to: 'jzproject#analysis'
  get "/jzproject/makexlsx", to: 'jzproject#makexlsx'
  get "/jzproject/reset", to: 'jzproject#reset'
  get "/jzproject/resetWordcount", to: 'jzproject#resetWordcount'

  get "/zhproject", to: 'zhproject#index'
  post "/zhproject/quse_ans_comme", to: 'zhproject#quse_ans_comme'
  post "/zhproject/ans_comme", to: 'zhproject#ans_comme'
  post "/zhproject/additional", to: 'zhproject#additional_quest'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
