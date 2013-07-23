IVGCWholeSale::Application.routes.draw do

  get "contact_us/index"

  get "rates/index"

  get "services/index"

  get "about_us/index"

  get "admin/accountInfo"
  post "admin/accountTerminate"
  get "admin/accountList"
  post "admin/viewTickets"
  get "admin/viewTickets"
  get "admin/index"  
  resources :admin, :only => [:index]

  post "/responses/new"
  resources :responses
  post "tickets/new"
  get "tickets/viewResponses"
  resources :tickets

  post "accounts/bankTransferSubmit"
  get "accounts/bankTransferSubmit"
  get "accounts/wuPayment"
  get "accounts/bankTranfers"
  post "accounts/paymentConfirm"
  get "accounts/paymentConfirm"
  post "accounts/addCredits"
  get "accounts/addCredits"
  get "accounts/addCreditsSubmit"
  post "accounts/addCreditsSubmit"
  get "accounts/creditAdded"
  get "accounts/deleteIP"
  post "accounts/updateIP"
  get "accounts/updateIP"
  get "accounts/manageIP"
  get "accounts/viewCDR"
  post "accounts/formatDate"
  get "accounts/updateAccount"
  get "accounts/doUpdate"
  post "accounts/doUpdate"
  get "accounts/index"

  get "signups/signUp"
  post "signups/signUp"

  get "contact_us/contactUs"
  post "contact_us/contactUs"
  get "contact_us/thanksForContacting"

  get "sessions/destroy"
  resources :sessions
  resources :accounts
  resources :signups
  resources :about_us
  resources :services
  resources :rates
  resources :contact_us

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'accounts#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
