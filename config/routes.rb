Rails.application.routes.draw do
  get 'params/logging'
  get 'params/auth'
  post 'params/check_auth', as: 'check'
  root 'params#any'
  match '*path', controller: 'params', action: 'any', via: :all, as: :any
end
