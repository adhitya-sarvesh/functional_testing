Rails.application.routes.draw do
  resources :workflows
  # sidekiq
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :parameters 

  resources :scenarios, except: :show do
    collection do
      post :copy
      get :mytestplan
      get :othertestplan
    end
    resources :parameters 
    get :generate, on: :member
  end

  resources :requests, only: [:index, :new, :create, :show] do
    get :status, on: :member
  end

  resources :imports_scenarios, only: [:index, :show] do
    get :link, on: :member
  end

  resources :solutions, except: [:show, :destroy] do
    get :membership, on: :member
    get :prerequisite, on: :member
  end

  resources :workflows, except: :show do
    resources :scenarios
    resources :scenarios_workflows
  end  

  get :help, to: 'pages#help'
  get '/download_report_pdf/:id', to: 'requests#download_report_pdf'
  get '/login', to: 'pages#login'
  post '/login', to: 'pages#associate'
  get '/logout', to: 'pages#destroy_session'
  root 'pages#login'
end
