Rails.application.routes.draw do
    resources :cores do
        collection { post :import_core_data }
    end
    get 'core_import_page' => 'cores#import_page'

    resources :gcses do
        collection { post :import }
        collection { post :batch_status }
    end
    get 'import_page' => 'gcses#import_page'

    post 'search_result_page_core' => 'search#search_result_core'
    post 'search_result_page' => 'search#search_result'
    root 'search#index'
end
