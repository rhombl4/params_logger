Rails.application.routes.draw do
  get 'params/logging'
  root 'params#logging'
  match '*path', controller: 'params', action: 'logging', via: :all, as: :any_path
    # :path=> /.*/,
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
