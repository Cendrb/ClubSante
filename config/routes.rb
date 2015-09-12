Rails.application.routes.draw do

  get 'global_settings/pass' => "global_settings#pass_form", as: "global_pass_form"

  post 'global_settings/pass' => "global_settings#pass_set", as: "global_pass_set"

  controller :navigation do
    get 'summary' => 'navigation#summary', as: 'nav_summary'
    get 'timetable' => 'navigation#reservations', as: 'nav_reservations'
    get 'tickets' => 'navigation#tickets', as: 'nav_tickets'
    get 'goals' => 'navigation#goals', as: 'nav_goals'
    get 'my_account' => 'navigation#my_account', as: 'nav_my_account'
    get 'administration' => 'navigation#administration', as: 'nav_administration'
  end

  resources :exercise_modifications

  resources :coaches

  resources :therapy_categories

  resources :goals

  resources :records

  resources :tracked_values

  resources :available_values

  controller :tickets do
    post "tickets/mark_as_paid" => "tickets#mark_as_paid"
  end
  resources :tickets

  resources :entries

  controller :exercise_templates do
    get 'exercise_templates/multi_edit' => "exercise_templates#multi_edit"
    post 'exercise_templates/multi_edit' => "exercise_templates#multi_update", as: "multi_update"
  end
  resources :exercise_templates

  resources :timetable_templates, except: :show
  
  resources :timetable_modifications, except: :show

  get 'calendars/show'

  get 'users/tracked_value_chart' => "users#tracked_value_chart", as: 'tracked_value_chart'

  resources :users
  
  controller :users do
    get 'users/:id/admin_edit' => "users#admin_edit", as: "admin_edit_user"
    patch 'users/:id/admin_update' => "users#admin_update"
  end
  
  controller :exercise_register do
    post 'registering_handler/subscribe' => "exercise_register#subscribe", as: 'subscribe'
    post 'registering_handler/unsubscribe_from' => "exercise_register#unsubscribe_from", as: 'unsubscribe'
    post 'registering_handler/admin_edit' => "exercise_register#admin_edit"
  end

  resources :exercises

  resources :therapies
  
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    get 'logout' => :destroy
  end
  
  controller :calendars do
    get 'calendars/:id' => :show, as: :calendar
    get 'calendars/:id/final' => :show_final, as: :calendar_final
  end
  
  root to: 'navigation#reservations'
  
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
