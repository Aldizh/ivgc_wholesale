IVGCWholeSale::Application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    get "services/reseller"
    get "services/wholesale"
    get "voip_resellers/voipResellerSignUp"
    post "voip_resellers/voipResellerSignUp"
    get "voip_resellers/thanksForSigningUp"


    get "rates/index"
    get "rates/displayRate"
    post "rates/displayRate"

    get "admin/accountInfo"
    post "admin/accountTerminate"
    get "admin/accountList"
    post "admin/viewTickets"
    get "admin/viewTickets"
    get "admin/index"
    resources :admin

    post "/responses/new"
    resources :responses

    post "tickets/new"
    get "tickets/viewResponses"
    resources :tickets

    get "accounts/instructions"
    post "accounts/forgotPasswordSubmit"
    get "accounts/forgotPasswordSubmit"
    post "accounts/forgotPassword"
    get "accounts/forgotPassword"
    get "accounts/displayWU"
    get "accounts/displayBank"
    get "accounts/bankDescription"
    get "accounts/paypalPayment"
    get "accounts/creditCardPayment"
    post "accounts/wuPaymentSubmit"
    get "accounts/wuPaymentSubmit"
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

    get "signups/signUp"
    post "signups/signUp"

    get "contact_us/contactUs"
    post "contact_us/contactUs"
    get "contact_us/thanksForContacting"

    get "voip_resellers/voipResellerSignUp"
    get "sessions/destroy"
    resources :home, only: :index
    resources :sessions
    resources :accounts
    resources :signups
    resources :about_us
    resources :services
    resources :rates do
      collection { post :import }
    end  
    resources :contact_us
    resources :voip_resellers

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
    root :to => 'sessions#new'
    # See how all your routes lay out with "rake routes"

    # This is a legacy wild controller route that's not recommended for RESTful applications.
    # Note: This route will make all actions in every controller accessible via GET requests.
    # match ':controller(/:action(/:id))(.:format)'
  end
  #match '*path', to: redirect("/#{I18n.default_locale}/%{path}")
  match '', to: redirect("/#{I18n.default_locale}")
end
