class DashboardService

    def dash_starter
        ### This is "9. !MEGA ReCalc!" Method - 9-in-1 Method!
        ## 1. Accounts ReCalc Method
        cores_dash
        ## 2. Contacts ReCalc Method
        staffers_dash
        ## 3. Crone Jobs ReCalc Method
        delayed_jobs_dash
        ## 4. Franchise ReCalc Method
        franchise_dash
        ## 5. GeoLocations ReCalc Method
        geo_locations_dash
        ## 6. Indexer ReCalc Method
        indexer_dash
        ## 7. Users ReCalc Method
        users_dash
        ## 8. WhoIs ReCalc Method
        whos_dash
    end

    ## 1. Accounts ReCalc Method
    def cores_dash
        ### === CORE STATUS COUNTS === ###
        all_cores_total = Core.count
        acct_merge_stat_count = Core.all.map(&:acct_merge_stat).uniq.count
        acct_merge_stat_dt_count = Core.all.map(&:acct_merge_stat_dt).uniq.count
        cont_merge_stat_count = Core.all.map(&:cont_merge_stat).uniq.count
        cont_merge_stat_dt_count = Core.all.map(&:cont_merge_stat_dt).uniq.count

        bds_status_count = Core.all.map(&:bds_status).uniq.count
        bds_status_list = Core.all.map(&:bds_status).uniq

        staff_indexer_status_count = Core.all.map(&:staff_indexer_status).uniq.count
        staff_indexer_status_list = Core.all.map(&:staff_indexer_status).uniq
        location_indexer_status_count = Core.all.map(&:location_indexer_status).uniq.count
        location_indexer_status_list = Core.all.map(&:location_indexer_status).uniq
        domain_status_count = Core.all.map(&:domain_status).uniq.count
        domain_status_list = Core.all.map(&:domain_status).uniq
        staffer_status_count = Core.all.map(&:staffer_status).uniq.count
        staffer_status_list = Core.all.map(&:staffer_status).uniq
        geo_status_count = Core.all.map(&:geo_status).uniq.count
        geo_status_list = Core.all.map(&:geo_status).uniq
        who_status_count = Core.all.map(&:who_status).uniq.count
        who_status_list = Core.all.map(&:who_status).uniq

        puts "\n\n============ (Core / Accounts Status Counts) ============\n"
        puts "all_cores_total: #{all_cores_total}"
        puts "bds_status_count: #{bds_status_count}"
        puts "bds_status_list: #{bds_status_list}\n\n"
        puts "staff_indexer_status_count: #{staff_indexer_status_count}"
        puts "staff_indexer_status_list: #{staff_indexer_status_list}\n\n"
        puts "location_indexer_status_count: #{location_indexer_status_count}"
        puts "location_indexer_status_list: #{location_indexer_status_list}\n\n"
        puts "domain_status_count: #{domain_status_count}"
        puts "domain_status_list: #{domain_status_list}\n\n"
        puts "staffer_status_count: #{staffer_status_count}"
        puts "staffer_status_list: #{staffer_status_list}\n\n"
        puts "geo_status_count: #{geo_status_count}"
        puts "geo_status_list: #{geo_status_list}\n\n"
        puts "who_status_count: #{who_status_count}"
        puts "who_status_list: #{who_status_list}\n\n"

        ### === CORE CRM BASICS COUNTS === ###
        # sfdc_acct_count = Core.all.map(&:sfdc_acct).uniq.count
        # sfdc_id_count = Core.all.map(&:sfdc_id).uniq.count
        # crm_acct_pin_count = Core.all.map(&:crm_acct_pin).uniq.count
        # sfdc_ph_count = Core.all.map(&:sfdc_ph).uniq.count
        # crm_phone_count = Core.all.map(&:crm_phone).uniq.count

        ### === CORE CRM ADDRESS COUNTS === ###
        # full_address_count = Core.all.map(&:full_address).uniq.count
        # sfdc_street_count = Core.all.map(&:sfdc_street).uniq.count
        # sfdc_city_count = Core.all.map(&:sfdc_city).uniq.count
        # sfdc_state_count = Core.all.map(&:sfdc_state).uniq.count
        # sfdc_zip_count = Core.all.map(&:sfdc_zip).uniq.count

        ### === CORE CRM DIGITAL COUNTS === ###
        # sfdc_url_count = Core.all.map(&:sfdc_url).uniq.count
        # sfdc_clean_url_count = Core.all.map(&:sfdc_clean_url).uniq.count
        # staff_link_count = Core.all.map(&:staff_link).uniq.count
        # staff_text_count = Core.all.map(&:staff_text).uniq.count
        # location_link_count = Core.all.map(&:location_link).uniq.count
        # location_text_count = Core.all.map(&:location_text).uniq.count
        # sfdc_template_count = Core.all.map(&:sfdc_template).uniq.count
        #
        # sfdc_franchise_count = Core.all.map(&:sfdc_franchise).uniq.count
        # sfdc_franch_cat_count = Core.all.map(&:sfdc_franch_cat).uniq.count
        # acct_source_count = Core.all.map(&:acct_source).uniq.count
        # sfdc_franch_cons_count = Core.all.map(&:sfdc_franch_cons).uniq.count

        ### === EXTRA GEO / CORE ACCOUNT STUFF === ###
        # sfdc_tier_count = Core.all.map(&:sfdc_tier).uniq.count
        # sfdc_sales_person_count = Core.all.map(&:sfdc_sales_person).uniq.count
        # sfdc_type_count = Core.all.map(&:sfdc_type).uniq.count
        # sfdc_ult_grp_count = Core.all.map(&:sfdc_ult_grp).uniq.count
        # sfdc_group_count = Core.all.map(&:sfdc_group).uniq.count
        # temporary_id_count = Core.all.map(&:temporary_id).uniq.count
        # geo_acct_name_count = Core.all.map(&:geo_acct_name).uniq.count
        # cop_coordinates_count = Core.all.map(&:cop_coordinates).uniq.count
        # cop_template_count = Core.all.map(&:cop_template).uniq.count
        # cop_franch_count = Core.all.map(&:cop_franch).uniq.count
        # conf_cat_count = Core.all.map(&:conf_cat).uniq.count
        # sfdc_acct_url_count = Core.all.map(&:sfdc_acct_url).uniq.count
        # sfdc_ult_grp_id_count = Core.all.map(&:sfdc_ult_grp_id).uniq.count
        # sfdc_group_id_count = Core.all.map(&:sfdc_group_id).uniq.count
        # img_url_count = Core.all.map(&:img_url).uniq.count
        # sfdc_ult_rt_count = Core.all.map(&:sfdc_ult_rt).uniq.count
        # sfdc_grp_rt_count = Core.all.map(&:sfdc_grp_rt).uniq.count

        ### === CORE GEO / COP ADDRESS COUNTS === ###
        # latitude_count = Core.all.map(&:latitude).uniq.count
        # longitude_count = Core.all.map(&:longitude).uniq.count
        # coordinates_count = Core.all.map(&:coordinates).uniq.count
        # geo_full_address_count = Core.all.map(&:geo_full_address).uniq.count
        #web_acct_pin_count = Core.all.map(&:web_acct_pin).uniq.count
        # cop_lat_count = Core.all.map(&:cop_lat).uniq.count
        # cop_lon_count = Core.all.map(&:cop_lon).uniq.count
        # geo_street_count = Core.all.map(&:geo_street).uniq.count
        # geo_city_count = Core.all.map(&:geo_city).uniq.count
        # geo_state_count = Core.all.map(&:geo_state).uniq.count
        # geo_zip_count = Core.all.map(&:geo_zip).uniq.count
        # geo_ph_count = Core.all.map(&:geo_ph).uniq.count
        # geo_url_count = Core.all.map(&:geo_url).uniq.count

    end

    ## 2. Contacts ReCalc Method
    def staffers_dash
        staffers_total = Staffer.count
        staffer_status_count = Staffer.all.map(&:staffer_status).uniq.count
        cont_status_count = Staffer.all.map(&:cont_status).uniq.count
        cont_source_count = Staffer.all.map(&:cont_source).uniq.count
        acct_pin_count = Staffer.all.map(&:acct_pin).uniq.count
        cont_pin_count = Staffer.all.map(&:cont_pin).uniq.count
        sfdc_id_count = sfdc_id = Staffer.all.map(&:sfdc_id).uniq.count
        acct_name_count = Staffer.all.map(&:acct_name).uniq.count
        email_count = Staffer.all.map(&:email).uniq.count
        sfdc_sales_person_count = Staffer.all.map(&:sfdc_sales_person).uniq.count
        sfdc_type_count = Staffer.all.map(&:sfdc_type).uniq.count
        sfdc_cont_id_count = Staffer.all.map(&:sfdc_cont_id).uniq.count
        sfdc_tier_count = Staffer.all.map(&:sfdc_tier).uniq.count
        domain_count = Staffer.all.map(&:domain).uniq.count
        fname_count = Staffer.all.map(&:fname).uniq.count
        lname_count = Staffer.all.map(&:lname).uniq.count
        fullname_count = Staffer.all.map(&:fullname).uniq.count
        job_count = Staffer.all.map(&:job).uniq.count
        job_raw_count = Staffer.all.map(&:job_raw).uniq.count
        phone_count = Staffer.all.map(&:phone).uniq.count

        puts "\n\n============ (Staffers / Contacts Counts) ============\n"
        puts "staffers_total: #{staffers_total}"
        puts "staffer_status_count: #{staffer_status_count}"
        puts "cont_status_count: #{cont_status_count}"
        puts "job_count: #{job_count}"
        puts "job_raw_count: #{job_raw_count}"
        puts "domain_count: #{domain_count}"
        puts "cont_source_count: #{cont_source_count}"
        puts "acct_pin_count: #{acct_pin_count}"
        puts "cont_pin_count: #{cont_pin_count}"
        puts "sfdc_id_count: #{sfdc_id_count}"
        puts "acct_name_count: #{acct_name_count}"
        puts "email_count: #{email_count}"
        puts "sfdc_sales_person_count: #{sfdc_sales_person_count}"
        puts "sfdc_type_count: #{sfdc_type_count}"
        puts "sfdc_cont_id_count: #{sfdc_cont_id_count}"
        puts "sfdc_tier_count: #{sfdc_tier_count}"
        puts "fname_count: #{fname_count}"
        puts "lname_count: #{lname_count}"
        puts "fullname_count: #{fullname_count}"
        puts "phone_count: #{phone_count}"
    end

    ## 3. Crone Jobs ReCalc Method
    def delayed_jobs_dash
        delayed_jobs_total = DelayedJob.count
        priority_count = DelayedJob.all.map(&:priority).uniq.count
        attempts_count = DelayedJob.all.map(&:attempts).uniq.count
        handler_count = DelayedJob.all.map(&:handler).uniq.count
        last_error_count = DelayedJob.all.map(&:last_error).uniq.count
        run_at_count = DelayedJob.all.map(&:run_at).uniq.count
        locked_at_count = DelayedJob.all.map(&:locked_at).uniq.count
        failed_at_count = DelayedJob.all.map(&:failed_at).uniq.count
        locked_by_count = DelayedJob.all.map(&:locked_by).uniq.count
        queue_count = DelayedJob.all.map(&:queue).uniq.count
        created_at_count = DelayedJob.all.map(&:created_at).uniq.count
        updated_at_count = DelayedJob.all.map(&:updated_at).uniq.count

        puts "\n\n============ (Delayed Jobs Counts) ============\n"
        puts "delayed_jobs_total: #{delayed_jobs_total}"
        puts "priority_count: #{priority_count}"
        puts "attempts_count: #{attempts_count}"
        puts "handler_count: #{handler_count}"
        puts "last_error_count: #{last_error_count}"
        puts "run_at_count: #{run_at_count}"
        puts "locked_at_count: #{locked_at_count}"
        puts "failed_at_count: #{failed_at_count}"
        puts "locked_by_count: #{locked_by_count}"
        puts "queue_count: #{queue_count}"
        puts "created_at_count: #{created_at_count}"
        puts "updated_at_count: #{updated_at_count}"
    end

    ## 4. Franchise ReCalc Method
    def franchise_dash
        franchise_total = InHostPo.count
        term_count = InHostPo.all.map(&:term).uniq.count
        consolidated_term_count = InHostPo.all.map(&:consolidated_term).uniq.count
        category_count = InHostPo.all.map(&:category).uniq.count

        puts "\n\n============ (Franchise Counts) ============\n"
        puts "franchise_total: #{franchise_total}"
        puts "term_count: #{term_count}"
        puts "consolidated_term_count: #{consolidated_term_count}"
        puts "category_count: #{category_count}"
    end

    ## 5. GeoLocations ReCalc Method
    def geo_locations_dash
        location_total = Location.count
        location_status_count = Location.all.map(&:location_status).uniq.count
        sts_geo_crm_count = Location.all.map(&:sts_geo_crm).uniq.count
        sts_url_count = Location.all.map(&:sts_url).uniq.count
        sts_root_count = Location.all.map(&:sts_root).uniq.count
        sts_acct_count = Location.all.map(&:sts_acct).uniq.count
        sts_addr_count = Location.all.map(&:sts_addr).uniq.count
        sts_ph_count = Location.all.map(&:sts_ph).uniq.count
        sts_duplicate_count = Location.all.map(&:sts_duplicate).uniq.count
        url_sts_count = Location.all.map(&:url_sts).uniq.count
        acct_sts_count = Location.all.map(&:acct_sts).uniq.count
        addr_sts_count = Location.all.map(&:addr_sts).uniq.count
        ph_sts_count = Location.all.map(&:ph_sts).uniq.count
        latitude_count = Location.all.map(&:latitude).uniq.count
        longitude_count = Location.all.map(&:longitude).uniq.count
        city_count = Location.all.map(&:city).uniq.count
        state_count = Location.all.map(&:state).uniq.count
        state_code_count = Location.all.map(&:state_code).uniq.count
        postal_code_count = Location.all.map(&:postal_code).uniq.count
        coordinates_count = Location.all.map(&:coordinates).uniq.count
        acct_name_count = Location.all.map(&:acct_name).uniq.count
        group_name_count = Location.all.map(&:group_name).uniq.count
        ult_group_name_count = Location.all.map(&:ult_group_name).uniq.count
        source_count = Location.all.map(&:source).uniq.count
        sfdc_id_count = Location.all.map(&:sfdc_id).uniq.count
        tier_count = Location.all.map(&:tier).uniq.count
        sales_person_count = Location.all.map(&:sales_person).uniq.count
        acct_type_count = Location.all.map(&:acct_type).uniq.count
        url_count = Location.all.map(&:url).uniq.count
        street_count = Location.all.map(&:street).uniq.count
        address_count = Location.all.map(&:address).uniq.count
        temporary_id_count = Location.all.map(&:temporary_id).uniq.count
        geo_acct_name_count = Location.all.map(&:geo_acct_name).uniq.count
        geo_full_addr_count = Location.all.map(&:geo_full_addr).uniq.count
        phone_count = Location.all.map(&:phone).uniq.count
        map_url_count = Location.all.map(&:map_url).uniq.count
        img_url_count = Location.all.map(&:img_url).uniq.count
        place_id_count = Location.all.map(&:place_id).uniq.count
        crm_source_count = Location.all.map(&:crm_source).uniq.count
        geo_root_count = Location.all.map(&:geo_root).uniq.count
        crm_root_count = Location.all.map(&:crm_root).uniq.count
        crm_url_count = Location.all.map(&:crm_url).uniq.count
        geo_franch_term_count = Location.all.map(&:geo_franch_term).uniq.count
        geo_franch_cons_count = Location.all.map(&:geo_franch_cons).uniq.count
        geo_franch_cat_count = Location.all.map(&:geo_franch_cat).uniq.count
        crm_franch_term_count = Location.all.map(&:crm_franch_term).uniq.count
        crm_franch_cons_count = Location.all.map(&:crm_franch_cons).uniq.count
        crm_franch_cat_count = Location.all.map(&:crm_franch_cat).uniq.count
        crm_phone_count = Location.all.map(&:crm_phone).uniq.count
        geo_type_count = Location.all.map(&:geo_type).uniq.count
        coord_id_arr_count = Location.all.map(&:coord_id_arr).uniq.count
        sfdc_acct_url_count = Location.all.map(&:sfdc_acct_url).uniq.count
        street_num_count = Location.all.map(&:street_num).uniq.count
        street_text_count = Location.all.map(&:street_text).uniq.count
        crm_street_count = Location.all.map(&:crm_street).uniq.count
        crm_city_count = Location.all.map(&:crm_city).uniq.count
        crm_state_count = Location.all.map(&:crm_state).uniq.count
        crm_zip_count = Location.all.map(&:crm_zip).uniq.count
        crm_url_redirect_count = Location.all.map(&:crm_url_redirect).uniq.count
        geo_url_redirect_count = Location.all.map(&:geo_url_redirect).uniq.count
        url_arr_count = Location.all.map(&:url_arr).uniq.count
        duplicate_arr_count = Location.all.map(&:duplicate_arr).uniq.count
        cop_franch_arr_count = Location.all.map(&:cop_franch_arr).uniq.count
        cop_franch_count = Location.all.map(&:cop_franch).uniq.count
        sfdc_acct_pin_count = Location.all.map(&:sfdc_acct_pin).uniq.count
        geo_acct_pin_count = Location.all.map(&:geo_acct_pin).uniq.count

        puts "\n\n============ (GeoLocation Counts) ============\n"
        puts "location_total: #{location_total}"
        puts "location_status_count: #{location_status_count}"
        puts "sts_geo_crm_count: #{sts_geo_crm_count}"
        puts "sts_url_count: #{sts_url_count}"
        puts "sts_root_count: #{sts_root_count}"
        puts "sts_acct_count: #{sts_acct_count}"
        puts "sts_addr_count: #{sts_addr_count}"
        puts "sts_ph_count: #{sts_ph_count}"
        puts "sts_duplicate_count: #{sts_duplicate_count}"
        puts "url_sts_count: #{url_sts_count}"
        puts "acct_sts_count: #{acct_sts_count}"
        puts "addr_sts_count: #{addr_sts_count}"
        puts "ph_sts_count: #{ph_sts_count}"
        puts "latitude_count: #{latitude_count}"
        puts "longitude_count: #{longitude_count}"
        puts "city_count: #{city_count}"
        puts "state_count: #{state_count}"
        puts "state_code_count: #{state_code_count}"
        puts "postal_code_count: #{postal_code_count}"
        puts "coordinates_count: #{coordinates_count}"
        puts "acct_name_count: #{acct_name_count}"
        puts "group_name_count: #{group_name_count}"
        puts "ult_group_name_count: #{ult_group_name_count}"
        puts "source_count: #{source_count}"
        puts "sfdc_id_count: #{sfdc_id_count}"
        puts "tier_count: #{tier_count}"
        puts "sales_person_count: #{sales_person_count}"
        puts "acct_type_count: #{acct_type_count}"
        puts "url_count: #{url_count}"
        puts "street_count: #{street_count}"
        puts "address_count: #{address_count}"
        puts "temporary_id_count: #{temporary_id_count}"
        puts "geo_acct_name_count: #{geo_acct_name_count}"
        puts "geo_full_addr_count: #{geo_full_addr_count}"
        puts "phone_count: #{phone_count}"
        puts "map_url_count: #{map_url_count}"
        puts "img_url_count: #{img_url_count}"
        puts "place_id_count: #{place_id_count}"
        puts "crm_source_count: #{crm_source_count}"
        puts "geo_root_count: #{geo_root_count}"
        puts "crm_root_count: #{crm_root_count}"
        puts "crm_url_count: #{crm_url_count}"
        puts "geo_franch_term_count: #{geo_franch_term_count}"
        puts "geo_franch_cons_count: #{geo_franch_cons_count}"
        puts "geo_franch_cat_count: #{geo_franch_cat_count}"
        puts "crm_franch_term_count: #{crm_franch_term_count}"
        puts "crm_franch_cons_count: #{crm_franch_cons_count}"
        puts "crm_franch_cat_count: #{crm_franch_cat_count}"
        puts "crm_phone_count: #{crm_phone_count}"
        puts "geo_type_count: #{geo_type_count}"
        puts "coord_id_arr_count: #{coord_id_arr_count}"
        puts "sfdc_acct_url_count: #{sfdc_acct_url_count}"
        puts "street_num_count: #{street_num_count}"
        puts "street_text_count: #{street_text_count}"
        puts "crm_street_count: #{crm_street_count}"
        puts "crm_city_count: #{crm_city_count}"
        puts "crm_state_count: #{crm_state_count}"
        puts "crm_zip_count: #{crm_zip_count}"
        puts "crm_url_redirect_count: #{crm_url_redirect_count}"
        puts "geo_url_redirect_count: #{geo_url_redirect_count}"
        puts "url_arr_count: #{url_arr_count}"
        puts "duplicate_arr_count: #{duplicate_arr_count}"
        puts "cop_franch_arr_count: #{cop_franch_arr_count}"
        puts "cop_franch_count: #{cop_franch_count}"
        puts "sfdc_acct_pin_count: #{sfdc_acct_pin_count}"
        puts "geo_acct_pin_count: #{geo_acct_pin_count}"
    end

    ## 6. Indexer ReCalc Method
    def indexer_dash
        indexer_total = Indexer.count
        raw_url_count_count = Indexer.all.map(&:raw_url).uniq.count
        redirect_status_count_count = Indexer.all.map(&:redirect_status).uniq.count
        clean_url_count_count = Indexer.all.map(&:clean_url).uniq.count
        indexer_status_count_count = Indexer.all.map(&:indexer_status).uniq.count
        rt_sts_count_count = Indexer.all.map(&:rt_sts).uniq.count
        cont_sts_count_count = Indexer.all.map(&:cont_sts).uniq.count
        staff_url_count_count = Indexer.all.map(&:staff_url).uniq.count
        staff_text_count_count = Indexer.all.map(&:staff_text).uniq.count
        location_url_count_count = Indexer.all.map(&:location_url).uniq.count
        location_text_count_count = Indexer.all.map(&:location_text).uniq.count
        template_count_count = Indexer.all.map(&:template).uniq.count
        loc_status_count_count = Indexer.all.map(&:loc_status).uniq.count
        stf_status_count_count = Indexer.all.map(&:stf_status).uniq.count
        contact_status_count_count = Indexer.all.map(&:contact_status).uniq.count
        contacts_count_count_count = Indexer.all.map(&:contacts_count).uniq.count
        contacts_link_count_count = Indexer.all.map(&:contacts_link).uniq.count
        acct_name_count_count = Indexer.all.map(&:acct_name).uniq.count
        full_addr_count_count = Indexer.all.map(&:full_addr).uniq.count
        street_count_count = Indexer.all.map(&:street).uniq.count
        city_count_count = Indexer.all.map(&:city).uniq.count
        state_count_count = Indexer.all.map(&:state).uniq.count
        zip_count_count = Indexer.all.map(&:zip).uniq.count
        phone_count_count = Indexer.all.map(&:phone).uniq.count
        acct_pin_count_count = Indexer.all.map(&:acct_pin).uniq.count
        raw_street_count_count = Indexer.all.map(&:raw_street).uniq.count
        who_status_count_count = Indexer.all.map(&:who_status).uniq.count

        puts "\n\n============ (Indexer Counts) ============\n"
        puts "indexer_total: #{indexer_total}"
        puts "raw_url_count_count: #{raw_url_count_count}"
        puts "redirect_status_count_count: #{redirect_status_count_count}"
        puts "clean_url_count_count: #{clean_url_count_count}"
        puts "indexer_status_count_count: #{indexer_status_count_count}"
        puts "rt_sts_count_count: #{rt_sts_count_count}"
        puts "cont_sts_count_count: #{cont_sts_count_count}"
        puts "staff_url_count_count: #{staff_url_count_count}"
        puts "staff_text_count_count: #{staff_text_count_count}"
        puts "location_url_count_count: #{location_url_count_count}"
        puts "location_text_count_count: #{location_text_count_count}"
        puts "template_count_count: #{template_count_count}"
        puts "loc_status_count_count: #{loc_status_count_count}"
        puts "stf_status_count_count: #{stf_status_count_count}"
        puts "contact_status_count_count: #{contact_status_count_count}"
        puts "contacts_count_count_count: #{contacts_count_count_count}"
        puts "contacts_link_count_count: #{contacts_link_count_count}"
        puts "acct_name_count_count: #{acct_name_count_count}"
        puts "full_addr_count_count: #{full_addr_count_count}"
        puts "street_count_count: #{street_count_count}"
        puts "city_count_count: #{city_count_count}"
        puts "state_count_count: #{state_count_count}"
        puts "zip_count_count: #{zip_count_count}"
        puts "phone_count_count: #{phone_count_count}"
        puts "acct_pin_count_count: #{acct_pin_count_count}"
        puts "raw_street_count_count: #{raw_street_count_count}"
        puts "who_status_count_count: #{who_status_count_count}"
    end

    ## 7. Users ReCalc Method
    def users_dash
        user_total = User.count
        email_count = User.all.map(&:email).uniq.count
        last_sign_in_at_count = User.all.map(&:last_sign_in_at).uniq.count
        current_sign_in_ip_count = User.all.map(&:current_sign_in_ip).uniq.count
        last_sign_in_ip_count = User.all.map(&:last_sign_in_ip).uniq.count
        unconfirmed_email_count = User.all.map(&:unconfirmed_email).uniq.count
        first_name_count = User.all.map(&:first_name).uniq.count
        last_name_count = User.all.map(&:last_name).uniq.count
        work_phone_count = User.all.map(&:work_phone).uniq.count
        mobile_phone_count = User.all.map(&:mobile_phone).uniq.count
        role_count = User.all.map(&:role).uniq.count
        department_count = User.all.map(&:department).uniq.count

        puts "\n\n============ (Users Counts) ============\n"
        puts "user_total: #{user_total}"
        puts "email_count: #{email_count}"
        puts "last_sign_in_at_count: #{last_sign_in_at_count}"
        puts "current_sign_in_ip_count: #{current_sign_in_ip_count}"
        puts "last_sign_in_ip_count: #{last_sign_in_ip_count}"
        puts "unconfirmed_email_count: #{unconfirmed_email_count}"
        puts "first_name_count: #{first_name_count}"
        puts "last_name_count: #{last_name_count}"
        puts "work_phone_count: #{work_phone_count}"
        puts "mobile_phone_count: #{mobile_phone_count}"
        puts "role_count: #{role_count}"
        puts "department_count: #{department_count}"
    end

    ## 8. WhoIs ReCalc Method
    def whos_dash
        who_total = Who.count
        who_status_count = Who.all.map(&:who_status).uniq.count
        url_status_count = Who.all.map(&:url_status).uniq.count
        domain_count = Who.all.map(&:domain).uniq.count
        domain_id_count = Who.all.map(&:domain_id).uniq.count
        ip_count = Who.all.map(&:ip).uniq.count
        server1_count = Who.all.map(&:server1).uniq.count
        server2_count = Who.all.map(&:server2).uniq.count
        registrar_url_count = Who.all.map(&:registrar_url).uniq.count
        registrar_id_count = Who.all.map(&:registrar_id).uniq.count
        registrant_id_count = Who.all.map(&:registrant_id).uniq.count
        registrant_type_count = Who.all.map(&:registrant_type).uniq.count
        registrant_name_count = Who.all.map(&:registrant_name).uniq.count
        registrant_organization_count = Who.all.map(&:registrant_organization).uniq.count
        registrant_address_count = Who.all.map(&:registrant_address).uniq.count
        registrant_city_count = Who.all.map(&:registrant_city).uniq.count
        registrant_zip_count = Who.all.map(&:registrant_zip).uniq.count
        registrant_state_count = Who.all.map(&:registrant_state).uniq.count
        registrant_phone_count = Who.all.map(&:registrant_phone).uniq.count
        registrant_fax_count = Who.all.map(&:registrant_fax).uniq.count
        registrant_email_count = Who.all.map(&:registrant_email).uniq.count
        registrant_url_count = Who.all.map(&:registrant_url).uniq.count
        admin_id_count = Who.all.map(&:admin_id).uniq.count
        admin_type_count = Who.all.map(&:admin_type).uniq.count
        admin_name_count = Who.all.map(&:admin_name).uniq.count
        admin_organization_count = Who.all.map(&:admin_organization).uniq.count
        admin_address_count = Who.all.map(&:admin_address).uniq.count
        admin_city_count = Who.all.map(&:admin_city).uniq.count
        admin_zip_count = Who.all.map(&:admin_zip).uniq.count
        admin_state_count = Who.all.map(&:admin_state).uniq.count
        admin_phone_count = Who.all.map(&:admin_phone).uniq.count
        admin_fax_count = Who.all.map(&:admin_fax).uniq.count
        admin_email_count = Who.all.map(&:admin_email).uniq.count
        admin_url_count = Who.all.map(&:admin_url).uniq.count
        tech_id_count = Who.all.map(&:tech_id).uniq.count
        tech_type_count = Who.all.map(&:tech_type).uniq.count
        tech_name_count = Who.all.map(&:tech_name).uniq.count
        tech_organization_count = Who.all.map(&:tech_organization).uniq.count
        tech_address_count = Who.all.map(&:tech_address).uniq.count
        tech_city_count = Who.all.map(&:tech_city).uniq.count
        tech_zip_count = Who.all.map(&:tech_zip).uniq.count
        tech_state_count = Who.all.map(&:tech_state).uniq.count
        tech_phone_count = Who.all.map(&:tech_phone).uniq.count
        tech_fax_count = Who.all.map(&:tech_fax).uniq.count
        tech_email_count = Who.all.map(&:tech_email).uniq.count
        tech_url_count = Who.all.map(&:tech_url).uniq.count
        registrant_pin_count = Who.all.map(&:registrant_pin).uniq.count
        tech_pin_count = Who.all.map(&:tech_pin).uniq.count
        admin_pin_count = Who.all.map(&:admin_pin).uniq.count

        puts "\n\n============ (WhoIs Counts) ============\n"
        puts "who_total: #{who_total}"
        puts "who_status_count: #{who_status_count}"
        puts "url_status_count: #{url_status_count}"
        puts "domain_count: #{domain_count}"
        puts "domain_id_count: #{domain_id_count}"
        puts "ip_count: #{ip_count}"
        puts "server1_count: #{server1_count}"
        puts "server2_count: #{server2_count}"
        puts "registrar_url_count: #{registrar_url_count}"
        puts "registrar_id_count: #{registrar_id_count}"
        puts "registrant_id_count: #{registrant_id_count}"
        puts "registrant_type_count: #{registrant_type_count}"
        puts "registrant_name_count: #{registrant_name_count}"
        puts "registrant_organization_count: #{registrant_organization_count}"
        puts "registrant_address_count: #{registrant_address_count}"
        puts "registrant_city_count: #{registrant_city_count}"
        puts "registrant_zip_count: #{registrant_zip_count}"
        puts "registrant_state_count: #{registrant_state_count}"
        puts "registrant_phone_count: #{registrant_phone_count}"
        puts "registrant_fax_count: #{registrant_fax_count}"
        puts "registrant_email_count: #{registrant_email_count}"
        puts "registrant_url_count: #{registrant_url_count}"
        puts "admin_id_count: #{admin_id_count}"
        puts "admin_type_count: #{admin_type_count}"
        puts "admin_name_count: #{admin_name_count}"
        puts "admin_organization_count: #{admin_organization_count}"
        puts "admin_address_count: #{admin_address_count}"
        puts "admin_city_count: #{admin_city_count}"
        puts "admin_zip_count: #{admin_zip_count}"
        puts "admin_state_count: #{admin_state_count}"
        puts "admin_phone_count: #{admin_phone_count}"
        puts "admin_fax_count: #{admin_fax_count}"
        puts "admin_email_count: #{admin_email_count}"
        puts "admin_url_count: #{admin_url_count}"
        puts "tech_id_count: #{tech_id_count}"
        puts "tech_type_count: #{tech_type_count}"
        puts "tech_name_count: #{tech_name_count}"
        puts "tech_organization_count: #{tech_organization_count}"
        puts "tech_address_count: #{tech_address_count}"
        puts "tech_city_count: #{tech_city_count}"
        puts "tech_zip_count: #{tech_zip_count}"
        puts "tech_state_count: #{tech_state_count}"
        puts "tech_phone_count: #{tech_phone_count}"
        puts "tech_fax_count: #{tech_fax_count}"
        puts "tech_email_count: #{tech_email_count}"
        puts "tech_url_count: #{tech_url_count}"
        puts "registrant_pin_count: #{registrant_pin_count}"
        puts "tech_pin_count: #{tech_pin_count}"
        puts "admin_pin_count: #{admin_pin_count}"
    end









end # DashboardService class Ends ---
