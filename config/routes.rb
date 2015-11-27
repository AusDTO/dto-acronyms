Rails.application.routes.draw do

  resources :entries do
    collection do
      get :archived
    end
  end

  root to: redirect("/entries")

end
