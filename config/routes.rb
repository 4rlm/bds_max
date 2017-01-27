Rails.application.routes.draw do
  # resources :locations

  resources :locations do
      collection {post :import_csv_data}
  end
  get 'location/import_page' => 'locations#import_page'
  get 'location/search' => 'locations#search'


  resources :dashboards

  resources :staffers do
      collection { post :import_csv_data }
  end
  get 'staffer/import_page' => 'staffers#import_page'
  get 'staffer/search' => 'staffers#search'
  get 'staffer/acct_contacts' => 'staffers#acct_contacts'

    resources :cores do
        collection { post :import_core_data }
    end
    get 'core/import_page' => 'cores#import_page'
    get 'core/search' => 'cores#search'

    resources :gcses do
        collection { post :import }
        collection { post :batch_status }
    end
    get 'gcse/import_page' => 'gcses#import_page'
    get 'gcse/search' => 'gcses#search'

    #==== Criteria CSV Imports =========
    resources :exclude_roots do
        collection { post :import_csv_data }
    end
    get 'exclude_root/import_page' => 'exclude_roots#import_page'

    resources :in_host_dels do
        collection { post :import_csv_data }
    end
    get 'in_host_del/import_page' => 'in_host_dels#import_page'

    resources :in_host_pos do
        collection { post :import_csv_data }
    end
    get 'in_host_po/import_page' => 'in_host_pos#import_page'

    resources :in_text_dels do
        collection { post :import_csv_data }
    end
    get 'in_text_del/import_page' => 'in_text_dels#import_page'

    resources :in_text_pos do
        collection { post :import_csv_data }
    end
    get 'in_text_po/import_page' => 'in_text_pos#import_page'

    resources :solitaries do
        collection { post :import_csv_data }
    end
    get 'solitary/import_page' => 'solitaries#import_page'

    resources :criteria_indexer_staff_texts do
        collection { post :import_csv_data }
    end
    get 'criteria_indexer_staff_text/import_page' => 'criteria_indexer_staff_texts#import_page'

    resources :criteria_indexer_staff_hrefs do
        collection { post :import_csv_data }
    end
    get 'criteria_indexer_staff_href/import_page' => 'criteria_indexer_staff_hrefs#import_page'

    resources :criteria_indexer_loc_hrefs do
        collection { post :import_csv_data }
    end
    get 'criteria_indexer_loc_href/import_page' => 'criteria_indexer_loc_hrefs#import_page'

    resources :criteria_indexer_loc_texts do
        collection { post :import_csv_data }
    end
    get 'criteria_indexer_loc_text/import_page' => 'criteria_indexer_loc_texts#import_page'

    resources :indexer_locations do
        collection { post :import_csv_data }
    end
    get 'indexer_location/import_page' => 'indexer_locations#import_page'

    resources :indexer_staffs do
        collection { post :import_csv_data }
    end
    get 'indexer_staff/import_page' => 'indexer_staffs#import_page'

    resources :pending_verifications do
        collection { post :import_csv_data }
    end
    get 'pending_verification/import_page' => 'pending_verifications#import_page'
    #==== Criteria CSV Imports Ends=========

    #==== Delayed_Jobs_Interface Starts=========
    # match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]

    # # Clean Data Buttons
    # get 'gcse_cleaner_btn' => 'gcses#gcse_cleaner_btn'
    get 'auto_match_btn' => 'gcses#auto_match_btn'
    # get 'solitary_cleaner_btn' => 'solitaries#solitary_cleaner_btn'
    # get 'core_comp_cleaner_btn' => 'cores#core_comp_cleaner_btn'
    get 'franchiser_btn' => 'cores#franchiser_btn'
    get 'col_splitter_btn' => 'cores#col_splitter_btn'
    get 'staffer_sfdc_id_cleaner_btn' => 'staffers#staffer_sfdc_id_cleaner_btn'
    get 'indexer_staff_cleaner_btn' => 'indexer_staffs#indexer_staff_cleaner_btn'
    get 'indexer_location_cleaner_btn' => 'indexer_locations#indexer_location_cleaner_btn'
    get 'location_cleaner_btn' => 'locations#location_cleaner_btn'
    get 'geo_update_migrate_btn' => 'locations#geo_update_migrate_btn'

    # Quick Search Button
    get 'quick_dom_dom_res_2' => 'gcses#quick_dom_dom_res_2'
    get 'quick_dom_no_auto_match_2' => 'gcses#quick_dom_no_auto_match_2'
    get 'quick_core_view_queue' => 'cores#quick_core_view_queue'
    get 'gcse_unique_rooter' => 'gcses#gcse_unique_rooter'
    get 'solitary_migrator' => 'solitaries#solitary_migrator'
    get 'geo_starter_btn' => 'locations#geo_starter_btn'

    #==== Search Pages Start=========
    post 'search_result_page_core' => 'search#search_result_core'
    post 'search_result_page_gcse' => 'search#search_result_gcse'
    post 'search_result_page_staffer' => 'search#search_result_staffer'
    post 'search_result_page_location' => 'search#search_result_location'
    root 'search#index'

    # === Google API Route ===
    get '/search' => 'search#index'

end
