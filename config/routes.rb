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

    post 'search_result_page' => 'search#search_result'
    root 'search#index'
end
