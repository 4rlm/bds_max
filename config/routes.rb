Rails.application.routes.draw do
    resources :whos do
        collection { post :import_csv_data }
    end
    get 'who_starter_btn' => 'whos#who_starter_btn'
    get 'who/import_page' => 'whos#import_page'
    get 'who/search' => 'whos#search'

    resources :indexer_terms do
        collection { post :import_csv_data }
    end
    get 'indexer_term/import_page' => 'indexer_terms#import_page'

    resources :indexers do
        collection {post :import_csv_data}
        #   get :merge_data, on: :collection
    end
    get 'indexer/search' => 'indexers#search'
    get 'indexer/import_page' => 'indexers#import_page'
    get 'page_finder_btn' => 'indexers#page_finder_btn'
    get 'reset_errors_btn' => 'indexers#reset_errors_btn'
    get 'indexer_power_btn' => 'indexers#indexer_power_btn'
    get 'template_finder_btn' => 'indexers#template_finder_btn'
    get 'rooftop_data_getter_btn' => 'indexers#rooftop_data_getter_btn'
    get 'meta_scraper_btn' => 'indexers#meta_scraper_btn'

    resources :locations do
        collection {post :import_csv_data}
        get :merge_data, on: :collection
        get :flag_data, on: :collection
    end
    get 'location/import_page' => 'locations#import_page'
    get 'location/search' => 'locations#search'
    get 'geo_places_starter_btn' => 'locations#geo_places_starter_btn'
    get 'location_power_btn' => 'locations#location_power_btn'
    get 'turbo_matcher_btn' => 'locations#turbo_matcher_btn'
    get 'location_cleaner_btn' => 'locations#location_cleaner_btn'
    get 'geo_update_migrate_btn' => 'locations#geo_update_migrate_btn'
    # get 'geo_starter_btn' => 'locations#geo_starter_btn'

    resources :staffers do
        collection { post :import_csv_data }
    end
    get 'staffer/import_page' => 'staffers#import_page'
    get 'staffer/search' => 'staffers#search'
    get 'staffer/acct_contacts' => 'staffers#acct_contacts'
    get 'cs_data_getter_btn' => 'staffers#cs_data_getter_btn'
    get 'staffer_sfdc_id_cleaner_btn' => 'staffers#staffer_sfdc_id_cleaner_btn'
    get 'temporary_btn' => 'staffers#temporary_btn'

    resources :cores do
        collection { post :import_core_data }
        get :merge_data, on: :collection
        get :flag_data, on: :collection
        get :drop_data, on: :collection
    end
    get 'core/import_page' => 'cores#import_page'
    get 'core/search' => 'cores#search'
    # # Clean Data Buttons
    # get 'core_comp_cleaner_btn' => 'cores#core_comp_cleaner_btn'
    get 'anything_btn' => 'cores#anything_btn'
    get 'col_splitter_btn' => 'cores#col_splitter_btn'

    resources :in_host_pos do
        collection { post :import_csv_data }
    end
    get 'in_host_po/import_page' => 'in_host_pos#import_page'

    resources :dashboards do
        collection { post :import_csv_data }
    end
    get 'dashboard/import_page' => 'dashboards#import_page'
    get 'dashboard_mega_btn' => 'dashboards#dashboard_mega_btn'
    get 'cores_dash_btn' => 'dashboards#cores_dash_btn'
    get 'delayed_jobs_dash_btn' => 'dashboards#delayed_jobs_dash_btn'
    get 'franchise_dash_btn' => 'dashboards#franchise_dash_btn'
    get 'indexer_dash_btn' => 'dashboards#indexer_dash_btn'
    get 'geo_locations_dash_btn' => 'dashboards#geo_locations_dash_btn'
    get 'staffers_dash_btn' => 'dashboards#staffers_dash_btn'
    get 'users_dash_btn' => 'dashboards#users_dash_btn'
    get 'whos_dash_btn' => 'dashboards#whos_dash_btn'
    get 'summarize_data' => 'dashboards#summarize_data'


    devise_for :users

    #==== Delayed_Jobs_Interface Starts=========
    # match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]

    # #==== Search Pages Start=========
    post 'search_result_page_core' => 'search#search_result_core'
    post 'search_result_page_staffer' => 'search#search_result_staffer'
    post 'search_result_page_location' => 'search#search_result_location'
    post 'search_result_page_indexer' => 'search#search_result_indexer'
    post 'search_result_page_indexer' => 'search#search_result_indexer'


    get 'admin/index'
    get 'admin/change_user_level' => 'admin#change_user_level'
    get 'admin/delete_user' => 'admin#delete_user'

    root 'welcome#index'


    # Hide all CRUD actions 2017.03.10 ==================================

    # # === Google API Route ===
    # get '/search' => 'search#index'

    # resources :in_text_pos do
    #     collection { post :import_csv_data }
    # end
    # get 'in_text_po/import_page' => 'in_text_pos#import_page'
end
