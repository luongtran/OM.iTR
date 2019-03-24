Todo::Application.routes.draw do
  resources :teams do
    resources :team_members
  end
  mount Ckeditor::Engine => '/ckeditor'
  resources :tasks
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root to: "home#index"

  post 'send-tasks', to: 'team_members#send_tasks', :defaults => { :format => 'json' }
  
end
