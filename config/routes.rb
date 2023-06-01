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
  resources :register

  root to: "projects#index"
  get '/search_project', to: 'projects#search_project', as: :search_project
  get '/search_student', to: 'students#search_student',  as: :search_student
  get '/show_inactive_students', to: 'students#show_inactive_students', as: :inactive_students

  get "/sw.js", to: redirect('/404.html')

  resources :students do
    delete :destroy_selected, on: :collection
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
