Rails.application.routes.draw do
  resources :assignments
  devise_for :admins
  devise_for :users, controllers: { registrations: 'users' }
  resources :archives
  resources :reports
  resources :projects
  resources :feedbacks
  resources :classrooms
  resources :students
  resources :ods_projects
  resources :organizations
  resources :courses
  resources :login

  devise_scope :user do
    root to: 'devise/sessions#new'
    get '/users/sign_out', to: 'devise/sessions#destroy'
  end

  devise_scope :admin do
    get '/admins/sign_out', to: 'devise/sessions#destroy'
  end

  # Projetos
  get '/search_project', to: 'projects#search_project', as: :search_project

  # Coordenadores
  get '/responsibles', to: 'users#index_responsibles'
  get '/responsibles/new', to: 'users#new_responsible'
  post '/responsibles', to: 'users#create_responsible'
  get '/responsibles/:id', to: 'users#show_responsible'
  get '/responsibles/:id/edit', to: 'users#edit_responsible'
  patch 'responsibles/:id', to: 'users#update_responsible'
  put 'responsibles/:id', to: 'users#update_responsible'
  delete '/responsibles/:id', to: 'users#destroy_responsible'

  resources :users do
    post 'create_responsible', on: :collection
  end  

  # # Registro
  # get '/register', to: 'register#new'
  # post '/register', to: 'register#create'

  # Alunos
  resources :users do
    delete :destroy_selected, on: :collection
  end

  get '/access_denied', to: 'application#access_denied', as: 'access_denied'
  
  get '/search_student', to: 'users#search_student',  as: :search_student
  get '/show_inactive_students', to: 'users#show_inactive_students', as: :inactive_students
  
  get "/sw.js", to: redirect('/404.html')
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"
end
