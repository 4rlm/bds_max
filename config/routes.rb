Rails.application.routes.draw do
      resources :gcses do
        collection { post :import }
      end

      resources :gcses do
          collection do
              post "batch_status"
          end
      end

    get 'import_page' => 'gcses#import_page'

    root 'gcses#index'
end
