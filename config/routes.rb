Rails.application.routes.draw do

  post 'user_token' => 'user_token#create'
  # devise for rails web application access
  devise_for :users
  devise_scope :user do
     get 'login',  to: 'devise/sessions#new'
     get 'logout', to: 'devise/sessions#destroy'
  end
  
  # *********************************************************************************
  # CUSTOMER ORDERS
  # For Rails
  resources :customer_orders, only: [:index] do
    get  'utilities', on: :collection
    post 'import',    on: :collection
  end
  # For APIs
  scope '/api' do
    resources :customer_orders, only: [:index, :create, :show, :update] do
      get  'lastorder/:company_id', on: :collection, action: :get_last_order  
      # Events
      resources :events, only: [:index, :create], controller: :customer_order_events
   end
  end 

  # *********************************************************************************
  # WAREHOUSE RECEIPT
  # For Rails
  # resources :warehouse_receipts, only: [:index]
  # For APIs
  scope '/api' do
    resources :warehouse_receipts, only: [:create, :show, :update] do
      get  'lastorder/:company_id', on: :collection, action: :get_last_order  
      get  'customer_order/get_ids/:customer_order_id', on: :collection, action: :get_ids

      resources :events, only: [:index, :create]
    end
  end 

  # *********************************************************************************
  # INTERNAL ORDER (WR & SHIPMENTS)
  # For APIs
  scope '/api' do
    resources :internal_orders, only: [] do
      resources :items,  only: [:index], controller: :internal_orders, action: :items
    end
  end 

  # *********************************************************************************
  # STOCK ITEMS
  # For APIs
  scope '/api' do
    resources :items, only: [:create, :update]
  end 

  # *********************************************************************************
  # COMPANIES
  # For Rails
  resources :companies, only: [:index]
  # For APIs
  scope '/api' do
    resources :companies, only: [:index]
  end 

  # *********************************************************************************
  # COUNTRIES
  # For Rails
  resources :countries, only: [:index]
  # For APIs
  scope '/api' do
    resources :countries, only: [:index]
  end 

  # *********************************************************************************
  # ENTITIES
  # For Rails
  resources :entities, only: [:index] do
     get  'utilities', on: :collection
     post 'import',    on: :collection
     get  ':type',     on: :collection, action: :index   # to get different types of entities: (CUS)tomers, (CAR)riers, (SUP)pliers, (null):all
  end
  # For APIs
  scope '/api' do
    resources :entities, only: [:index, :show] do
       get  'type/:type', on: :collection, action: :index
    end
  end 

  # *********************************************************************************
  # EVENT TYPES
  # For Rails
  resources :event_types, only: [:index]
  # For APIs
  scope '/api' do
    resources :event_types, only: [:index]
  end 

  # *********************************************************************************
  # Utilities routes
  # as
  #    Download files: /download/log/<filename>.<ext>
  #                    => ApplicationController#download
  #                    PARAMS: {
  #                             "controller" => "application",
  #                             "action" => "download",
  #                             "type" => "log",
  #                             "id" => <filename>,
  #                             "format" => <ext>    // ej. "log"
  #                            }
  match 'download/:type/:id' => 'application#download', :via => [:get]

  # -------------------------------------------------------------------------------------
  # MAIN ROOT
  root to: 'customer_orders#index'
end
