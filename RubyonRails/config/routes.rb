Rails.application.routes.draw do

  get 'inquiries/new'
  get 'inquiries/create'
  get 'users/index'
  devise_for :users, controllers: { registrations: 'registrations', sessions: 'users/sessions' }
  get 'pages/home'
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
 end

  root to: redirect('/home')
  get 'home', to: 'pages#home', as: 'home'
  get 'about', to: 'pages#about', as: 'about'
  
  get "/clients/new", to: "clients#new"
  get 'clients', to: 'clients#index'
  get 'clients/:id/edit', to: 'clients#edit', as: 'edit_client'
  get 'global_moderator_index', to: 'clients#global_moderator_index'
  get 'expired_license', to: 'clients#expired_license'
  post 'update_registration_key', to: 'clients#update_registration_key'
  post 'user_mfa_sessions/reset_qr_code', to: 'user_mfa_sessions#reset_qr_code', as: :reset_qr_code_user_mfa_sessions


  
  get 'users', to:'users#index'
  get 'combined', to: 'clients#combined'

  get 'clinicians', to:'clinicians#index'

  get "/clinicians/new", to: "clinicians#new", as: 'new_clinician'
  get 'clinicians/:id/edit', to: 'clinicians#edit', as: 'edit_clinician'

  post 'stripe_checkout', to: 'stripe_checkout#create'
  get 'stripe_checkout', to: 'stripe_checkout#new'
  get '/stripe_checkout/success', to: 'stripe_checkout#success', as: 'success_stripe_payment'
  get '/stripe_checkout/failure', to: 'stripe_checkout#failure', as: 'failure_stripe_payment'

  post '/webhooks/stripe', to: 'webhooks#stripe'


  resources :global_moderators_dashboard, only: [:index] do
    post :create_discount, on: :collection
    post :create_key, on: :collection
  end
  delete 'global_moderators_dashboard/destroy_discount/:id', to: 'global_moderators_dashboard#destroy_discount', as: 'destroy_discount_global_moderators_dashboard'

  # Route for new user MFA session
  get 'user_mfa_sessions/new', to: 'user_mfa_sessions#new', as: :new_user_mfa_session
  # You might also need to define the create route if not already done
  post 'user_mfa_sessions', to: 'user_mfa_sessions#create', as: :user_mfa_session

  resources :users, only: [:index, :new, :create]
  resources :inquiries, only: [:new, :create]

  resources :billing_dashboard, only: [:index]
  # post '/change_payment_method', to: 'billing_dashboard#change_payment_method'
  post 'customer_portal', to: 'billing_dashboard#customer_portal'

  # config/routes.rb
  resources :user_mfa_sessions do
    get 'setup_google_auth', on: :collection
    get 'setup_email_auth', on: :collection
    get 'enter_email_code', on: :collection
    post 'verify_email_2fa', on: :collection

  end


  resources :clients do
    resources :emergency_contacts, only: [:create, :destroy, :new, :edit, :update]
    resources :dwt_tests do
      collection do
        get 'new_dwt_list1', to: 'dwt_tests#new_dwt_list1', as: 'dwt_list1'
        get 'new_dwt_list2', to: 'dwt_tests#new_dwt_list2', as: 'dwt_list2'
        get 'new_dwt_list3', to: 'dwt_tests#new_dwt_list3', as: 'dwt_list3'
        get 'new_dwt_list4', to: 'dwt_tests#new_dwt_list4', as: 'dwt_list4'
        get 'dwt_tests/:id', to: 'dwt_tests#show', as: 'show'
      end
        member do
          post 'apply_discount'
        end
  
      end
    resources :dnw_tests do
      collection do
        get 'new_dnw_list1', to: 'dnw_tests#new_dnw_list1', as: 'dnw_list1'
        get 'new_dnw_list2', to: 'dnw_tests#new_dnw_list2', as: 'dnw_list2'
        get 'new_dnw_list3', to: 'dnw_tests#new_dnw_list3', as: 'dnw_list3'
        get 'new_dnw_list4', to: 'dnw_tests#new_dnw_list4', as: 'dnw_list4'
        get 'dnw_tests/:id', to: 'dnw_tests#show', as: 'show'
      end
      member do
        post 'apply_discount'
      end

    end
    resources :rddt_tests do
      collection do
        get 'new_rddt_list1', to: 'rddt_tests#new_rddt_list1', as: 'rddt_list1'
        get 'new_rddt_list2', to: 'rddt_tests#new_rddt_list2', as: 'rddt_list2'
        get 'rddt_tests/:id', to: 'rddt_tests#show', as: 'show'
      end
      member do
        post 'apply_discount'
      end
    end
  end

end
