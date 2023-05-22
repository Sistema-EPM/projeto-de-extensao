Rails.application.routes.draw do
  resources :archives
  resources :reports
  resources :projects
  resources :feedbacks
  resources :classrooms
  resources :students
  resources :ods_projects
  resources :organizations
  resources :courses
  resources :responsibles

  root to: "projects#index"
  get '/search', to: 'projects#search'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
