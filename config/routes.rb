Rails.application.routes.draw do
  get 'metrics/index'
  get 'metrics/:id', :to => 'metrics#values'
  get 'metrics/:id/edit', :to => 'metrics#edit'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'metrics/index', :controller => 'metrics', :action => 'values'
  
end
