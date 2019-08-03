Rails.application.routes.draw do
    get '/items/:id', to: 'items#index'
    post '/items', to: 'items#create'
    put '/items', to: 'items#update'
    put '/items/order', to: 'items#order'
    
    
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
