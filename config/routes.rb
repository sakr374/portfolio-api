Rails.application.routes.draw do
  # Health check used by Render and other hosts.
  get "up" => "rails/health#show", as: :rails_health_check

  # Devise routes for admin authentication (outside namespaces)
  devise_for :admins,
             path: 'api/v1',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout'
             },
             controllers: {
               sessions: 'admins/sessions'
             },
             defaults: { format: :json }

  # Public API routes
  namespace :api do
    namespace :v1 do
      resources :projects, only: [:index, :show]
      resources :feedbacks, only: [:create]
      resource :profile_info, only: [:show], controller: 'profile_infos'
      resources :visitors, only: [:create], path: 'log_visit'
    end
  end

  # Admin routes for managing projects (protected with JWT)
  namespace :admins do
    resources :projects, only: [:index, :create, :update, :destroy] do
      collection do
        patch :reorder
      end
    end
    resources :feedbacks, only: [:index]
    resource :profile_info, only: [:show, :update], controller: 'profile_infos'
    get '/stats', to: 'stats#index'
  end
end