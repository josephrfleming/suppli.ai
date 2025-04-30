# config/routes.rb
require "sidekiq/web"

Rails.application.routes.draw do
  # Devise routes with cleaner URLs
  devise_for :users, path: "", path_names: {
    sign_in:  "login",
    sign_out: "logout",
    sign_up:  "register"
  }

  # Sidekiq UI (admin only, if Sidekiq is enabled)
  class AdminConstraint
    def self.matches?(request)
      id = request.session["warden.user.user.key"]&.dig(0, 0)
      id && User.find_by(id: id)&.admin?
    end
  end

  if Rails.application.config.active_job.queue_adapter == :sidekiq
    constraints AdminConstraint do
      mount Sidekiq::Web => "/sidekiq"
    end
  end

  # homepage
  root "home#index"

  # main app routes
  resources :products
  resources :categories, only: %i[index show]
  resources :tags,       only: %i[index show]

  resources :recommendation_sessions, only: %i[index new create show] do
    get :explanation, on: :member  # opens separately
  end

  # uptime check
  get "/up", to: -> { [200, { "Content-Type" => "text/plain" }, ["OK"]] }
end
