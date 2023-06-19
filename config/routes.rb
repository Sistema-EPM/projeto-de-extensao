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
  get '/responsibles/:id', to: 'users#show_responsible', as: :responsible
  get '/responsibles/:id/edit', to: 'users#edit_responsible', as: :edit_responsible
  patch 'responsibles/:id', to: 'users#update_responsible', as: :responsible_registration
  put 'responsibles/:id', to: 'users#update_responsible'
  delete 'destroy_selected', to: 'users#destroy_responsibles', as: :destroy_selected_responsibles

  resources :users do
    post 'create_responsible', on: :collection
    get 'edit_responsible', on: :collection
    get 'responsible_new', on: :collection
    get 'responsible', on: :collection
    get 'responsibles', on: :collection

    member do
      get 'reports', to: 'users#reports'
    end
  end  

  # Reportes
  patch '/approve_reports', to: 'reports#approve_reports', as: 'approve_reports'
  patch '/reprove_reports', to: 'reports#reprove_reports', as: 'reprove_reports'

  # Alunos
  resources :users do
    delete :destroy_selected, on: :collection
  end

  # Projetos
  resources :projects do
    delete :destroy_selected, on: :collection
  end

  # Turmas
  resources :classrooms do
    delete :destroy_selected, on: :collection
  end

  # Cusos
  resources :courses do
    delete :destroy_selected, on: :collection
  end

  # Reportes
  resources :reports do
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
