Rails.application.routes.draw do
  
  resources :goals

  controller :records do
    get "records/new_records", as: "new_records"
    post "records/new_records"
    post "records/create_records", as: "create_records"
  end

  resources :records

  resources :tracked_values

  resources :available_values

  resources :tickets

  resources :entries

  resources :exercise_templates

  resources :timetable_templates

  get 'calendars/show'

  get 'users/tracked_value_chart' => "users#tracked_value_chart", as: 'tracked_value_chart'

  resources :users
  
  controller :users do
    get 'users/:id/admin_edit' => "users#admin_edit", as: "admin_edit_user"
    patch 'users/:id/admin_update' => "users#admin_update"
    post 'users/subscribe_for_new'
    post 'users/subscribe_for_existing'
    post 'users/unsubscribe_from', as: 'unsubscribe'
  end

  resources :exercises

  resources :therapies
  
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    get 'logout' => :destroy
  end
  
  controller :calendars do
    get 'calendars/summary' => :summary, as: :calendar_summary
    get 'calendars/:id' => :show, as: :calendar
  end
  
  root to: 'users#summary'
  
  get 'user_summary' => 'users#summary', as: 'user_summary'
  
  get 'register' => 'users#new', as: 'register'
  delete 'destroy_account/:id', to: 'users#self_destroy', as: 'destroy_account'

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
