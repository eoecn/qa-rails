Rails.application.routes.draw do
  namespace :qa do
    resources :topics do
      resources :replies
      collection do
        get :new_topics_count
      end
    end
    resources :markdown
  end
end
