Todo::Application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  resources :teams do
    resources :team_members
  end
  root "pages#welcome"
  get 'pages/welcome', to: 'pages#welcome'
  
  resources :pages do
    collection do
      post 'welcome/edit'
      post 'about/edit'
      get 'welcome', to: 'welcome'
      get 'about',   to: 'about'
    end
  end
  resources :tasks
  devise_for :users, controllers: { registrations: 'users/registrations' }
  get ':team', to: 'pages#welcome', as: "team_welcome"
  #root to: "home#index"

  post 'send-tasks', to: 'team_members#send_tasks'
  get 'teams/:team_id/staff-emails', to: 'team_members#email_list', as: :email_list
  post 'mark-completed', to: 'tasks#completed_tasks', :defaults => { :format => 'json' }
  post 'sendUserEmailContent', to: 'team_members#send_emails', :defaults => { :format => 'json' }
  
end
