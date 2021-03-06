OneBody::Application.routes.draw do

  root to: redirect('/stream')

  resource :account do
    member do
      get :verify_code
      post :verify_code
      get  :select
      post :select
    end
  end

  resources :people do
    collection do
      get  :schema
      get  :import
      post :import
      post :hashify
      post :batch
      put  :import
    end
    member do
      get :favs
      get :testimony
      get :login
    end
    resources :friends do
      collection do
        post :reorder
      end
    end
    resources :relationships do
      collection do
        post :batch
      end
    end
    resource :account do
      member do
        get  :verify_code
        post :verify_code
        get  :select
        post :select
      end
    end
    resource :stream
    resource :photo
    resources :groups, :pictures, :groupies, :services, :albums, :verses
    resource :privacy, :blog, :calendar
  end

  resources :families do
    collection do
      get  :schema
      post :hashify
      post :batch
      post :select
    end
    resource :photo
    resources :relationships
    resources :people do
      member do
        post :update_position
      end
    end
    resource :search
  end

  resources :groups do
    collection do
      get  :batch
      post :batch
    end
    resources :memberships do
      collection do
        post   :batch
        delete :batch
      end
      resource :privacy
    end
    resources :messages do
      collection do
        post :new # XXX why??
      end
    end
    resources :attendance do
      collection do
        post :batch
      end
    end
    resources :tasks do
      member do
        patch :complete
        post :update_position
      end
    end
    resource :stream
    resource :photo
    resources :prayer_requests, :albums, :attachments
    resource :calendar
  end

  resources :memberships do
    collection do
      get  :batch
      post :batch
    end
  end

  resources :service_categories do
    collection do
      get :batch_edit
      get :close_batch_edit
    end
  end

  resources :albums do
    resources :pictures do
      member do
        get :next
        get :prev
      end
      resource :photo
    end
  end

  resources :messages do
    resources :attachments
  end

  resource :emails

  put 'setup_email' => 'emails#create_route'

  resources :tags, only: :show

  resources :pictures, :prayer_signups, :authentications, :shares,
            :comments, :prayer_requests, :generated_files

  resources :verses do
    get 'search', on: :collection
  end

  resource  :setup, :session, :search, :printable_directory, :privacy

  resource :stream do
    resources :people, controller: 'stream_people'
  end

  resources :news, as: :news_items
  get 'news', to: 'news#index'

  resources :attachments do
    member do
      get :get
    end
  end

  resources :pages, path: 'pages/admin' do
    resources :attachments
  end

  resources :documents do
    get :download, on: :member
  end

  resources :tasks do
    member do
      patch :complete
    end
  end


  get 'pages/*path' => 'pages#show_for_public', via: :get, as: :page_for_public

  get '/admin' => 'administration/dashboards#show'
  get '/admin/reports' => 'administration/reports#index'

  namespace :administration, path: :admin do
    resources :emails do
      collection do
        put :batch
      end
    end
    resources :settings do
      collection do
        put :batch
        put :reload
      end
    end
    resources :attendance do
      collection do
        get :prev
        get :next
      end
    end
    resources :syncs do
      member do
        post :create_items
      end
    end
    resources :deleted_people do
      collection do
        put :batch
      end
    end
    resources :updates, :admins, :membership_requests
    namespace :checkin do
      root to: 'dashboards#show'
      resource :dashboard
      resources :groups do
        put :batch, on: :collection
        put :reorder, on: :member
      end
      resources :times do
        resources :groups
      end
      resources :cards, :auths
    end
  end

  namespace :checkin do
    root to: 'interfaces#show'
    resource :interface
    resources :families, :people, :groups
  end
  resources :custom_reports
end
