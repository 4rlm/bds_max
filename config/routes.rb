Rails.application.routes.draw do
    resources :cores do
        collection { post :import_core_data }
    end
    get 'core_import_page' => 'cores#import_page'
    get 'core/search' => 'cores#search'

    resources :gcses do
        collection { post :import }
        collection { post :batch_status }
    end
    get 'import_page' => 'gcses#import_page'
    get 'gcse/search' => 'gcses#search'

    #==== Criteria CSV Imports =========
    resources :exclude_roots do
        collection { post :import_csv_data }
    end
    get 'exclude_root_import_page' => 'exclude_roots#import_page'

    resources :in_host_dels do
        collection { post :import_csv_data }
    end
    get 'in_host_del_import_page' => 'in_host_dels#import_page'

    resources :in_host_pos do
        collection { post :import_csv_data }
    end
    get 'in_host_po_import_page' => 'in_host_pos#import_page'

    resources :in_text_dels do
        collection { post :import_csv_data }
    end
    get 'in_text_del_import_page' => 'in_text_dels#import_page'

    resources :in_text_pos do
        collection { post :import_csv_data }
    end
    get 'in_text_po_import_page' => 'in_text_pos#import_page'

    resources :solitaries do
        collection { post :import_csv_data }
    end
    get 'solitary_import_page' => 'solitaries#import_page'

    resources :criteria_indexer_staff_texts do
        collection { post :import_csv_data }
    end
    get 'criteria_indexer_staff_text_import_page' => 'criteria_indexer_staff_texts#import_page'

    resources :criteria_indexer_staff_hrefs do
        collection { post :import_csv_data }
    end
    get 'criteria_indexer_staff_href_import_page' => 'criteria_indexer_staff_hrefs#import_page'

    resources :criteria_indexer_loc_hrefs do
        collection { post :import_csv_data }
    end
    get 'criteria_indexer_loc_href_import_page' => 'criteria_indexer_loc_hrefs#import_page'

    resources :criteria_indexer_loc_texts do
        collection { post :import_csv_data }
    end
    get 'criteria_indexer_loc_text_import_page' => 'criteria_indexer_loc_texts#import_page'

    resources :indexer_locations do
        collection { post :import_csv_data }
    end
    get 'indexer_location_import_page' => 'indexer_locations#import_page'

    resources :indexer_staffs do
        collection { post :import_csv_data }
    end
    get 'indexer_staff_import_page' => 'indexer_staffs#import_page'

    resources :pending_verifications do
        collection { post :import_csv_data }
    end
    get 'pending_verification_import_page' => 'pending_verifications#import_page'
    #==== Criteria CSV Imports Ends=========

    #==== Delayed_Jobs_Interface Starts=========
    # match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]

    #==== Search Pages Start=========
    post 'search_result_page_core' => 'search#search_result_core'
    post 'search_result_page_gcse' => 'search#search_result_gcse'
    root 'search#index'
end
