Rails.application.routes.draw do
  resources :users
  resources :archives
  resources :reports
  resources :projects
  resources :feedbacks
  resources :classrooms
  resources :students
  resources :users
  resources :ods_projects
  resources :organizations
  resources :courses
  resources :responsibles, only: [:new, :create]
  resources :login
  resources :register

  root to: "organizations#new"

  # Projetos
  get '/search_project', to: 'projects#search_project', as: :search_project

  # Registro
  get '/register', to: 'responsibles#new'
  post '/register', to: 'responsibles#create'

  # Alunos
  resources :users do
    delete :destroy_selected, on: :collection
  end
  
  get '/search_student', to: 'users#search_student',  as: :search_student
  get '/show_inactive_students', to: 'users#show_inactive_students', as: :inactive_students
  
  get "/sw.js", to: redirect('/404.html')
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"
end
