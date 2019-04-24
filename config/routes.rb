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
  #root to: "home#index"

  post 'send-tasks', to: 'team_members#send_tasks', :defaults => { :format => 'json' }
  post 'mark-completed', to: 'tasks#completed_tasks', :defaults => { :format => 'json' }
  
end
