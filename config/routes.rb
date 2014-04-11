PNPI::Application.routes.draw do
  
  root to: 'search#new'
  
  resources :people, controller: :resources, type: 'Person'
  resources :places, controller: :resources, type: 'Place'
  resources :things, controller: :resources, type: 'Thing'
  resources :samples, controller: :resources, type: 'Sample'
  
  get '/people/:person_id/:type/new' => 'resources#new', as: :new_resource_by_owner
  
  resources :categories, controller: :groupings, type: :category, only: :index
  resources :tags,       controller: :groupings, type: :tag,      only: :index
  
  post '/groupings/create/' => 'groupings#create',    as: :create_grouping
  post '/groupings/update/' => 'groupings#update',    as: :update_grouping
  post '/groupings/destroy/' => 'groupings#destroy',  as: :destroy_grouping
  
  devise_for :users, skip: [:registrations, :sessions]
  as :user do
    get  '/login' => 'sessions#new', as: :new_user_session
    post '/login' => 'sessions#create', as: :user_session
    get  '/logout' => 'sessions#destroy', as: :destroy_user_session
    get  '/people/:id/register/:signup_token' => 'registrations#new', as: :new_user_registration
    post '/people/register' => 'registrations#create', as: :registration
  end
 
  get '/resources/:type/:scope' => 'resources#index', as: :scoped_resources

  post '/search/tags/:id' => 'tags#show'
  post '/search/resources' => 'search#resources'
  post '/search/categories/:resource' => 'search#categories'
  post '/search/tags/:resource/:category' => 'search#tags'
  
  post '/search/filter/:resource/:category(/:page)' => 'search#filter'
  post '/search/text/:term(/:page)' => 'search#text'
  post '/search/all(/:page)' => 'search#all'
  
  get '/search/filter/:resource/:category(/:page)' => 'search#filter'
  get '/search/text/:term(/:page)' => 'search#text'
  get '/search/all(/:page)' => 'search#all'
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
