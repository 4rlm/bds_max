Rails.application.routes.draw do
  resources :indexer_locations
  resources :indexer_staffs
    resources :criteria_indexer_loc_texts
    resources :criteria_indexer_loc_hrefs
    resources :criteria_indexer_staff_hrefs
    resources :criteria_indexer_staff_texts
      resources :in_text_pos
    resources :in_text_negs
    resources :in_text_dels
    resources :in_suffix_dels
    resources :in_host_pos
    resources :in_host_negs
    resources :in_host_dels
    resources :exclude_roots
    resources :solitaries

    resources :cores do
        collection { post :import_core_data }
    end
    get 'core_import_page' => 'cores#import_page'

    resources :gcses do
        collection { post :import }
        collection { post :batch_status }
    end
    get 'import_page' => 'gcses#import_page'

#==== Criteria CSV Imports =========
    resources :exclude_roots do
        collection { post :import_csv_data }
    end
    get 'exclude_root_import_page' => 'exclude_roots#import_page'

    resources :in_host_dels do
        collection { post :import_csv_data }
    end
    get 'in_host_del_import_page' => 'in_host_dels#import_page'

    resources :in_host_negs do
        collection { post :import_csv_data }
    end
    get 'in_host_neg_import_page' => 'in_host_negs#import_page'

    resources :in_host_pos do
        collection { post :import_csv_data }
    end
    get 'in_host_po_import_page' => 'in_host_pos#import_page'

    resources :in_suffix_dels do
        collection { post :import_csv_data }
    end
    get 'in_suffix_del_import_page' => 'in_suffix_dels#import_page'

    resources :in_text_dels do
        collection { post :import_csv_data }
    end
    get 'in_text_del_import_page' => 'in_text_dels#import_page'

    resources :in_text_negs do
        collection { post :import_csv_data }
    end
    get 'in_text_neg_import_page' => 'in_text_negs#import_page'

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




    #==== Criteria CSV Imports Ends=========

    post 'search_result_page_core' => 'search#search_result_core'
    post 'search_result_page_gcse' => 'search#search_result_gcse'
    root 'search#index'
end
