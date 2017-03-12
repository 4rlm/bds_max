class DashboardService

    def dash_starter
        ### This is "9. !MEGA ReCalc!" Method - 9-in-1 Method!
        ## 1. Accounts ReCalc Method
        cores_dash
        ## 2. Contacts ReCalc Method
        staffers_dash
        ## 3. Crone Jobs ReCalc Method
        # delayed_jobs_dash
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

        ### === CORE STATUS (Uniq) COUNTS === ###
        acct_merge_stat_uniq_count = Core.all.map(&:acct_merge_stat).uniq.count
        acct_merge_stat_dt_uniq_count = Core.all.map(&:acct_merge_stat_dt).uniq.count
        cont_merge_stat_uniq_count = Core.all.map(&:cont_merge_stat).uniq.count
        cont_merge_stat_dt_uniq_count = Core.all.map(&:cont_merge_stat_dt).uniq.count

        bds_status_uniq_count = Core.all.map(&:bds_status).uniq.count
        bds_status_list = Core.all.map(&:bds_status).uniq

        staff_indexer_status_uniq_count = Core.all.map(&:staff_indexer_status).uniq.count
        staff_indexer_status_list = Core.all.map(&:staff_indexer_status).uniq
        location_indexer_status_uniq_count = Core.all.map(&:location_indexer_status).uniq.count
        location_indexer_status_list = Core.all.map(&:location_indexer_status).uniq
        domain_status_uniq_count = Core.all.map(&:domain_status).uniq.count
        domain_status_list = Core.all.map(&:domain_status).uniq
        staffer_status_uniq_count = Core.all.map(&:staffer_status).uniq.count
        staffer_status_list = Core.all.map(&:staffer_status).uniq
        geo_status_uniq_count = Core.all.map(&:geo_status).uniq.count
        geo_status_list = Core.all.map(&:geo_status).uniq
        who_status_uniq_count = Core.all.map(&:who_status).uniq.count
        who_status_list = Core.all.map(&:who_status).uniq

        puts "\n\n\n============ (Core (UNIQ) Status Counts) ============\n"
        puts "bds_status_uniq_count: #{bds_status_uniq_count}"
        puts "bds_status_list: #{bds_status_list}\n\n"
        puts "staff_indexer_status_uniq_count: #{staff_indexer_status_uniq_count}"
        puts "staff_indexer_status_list: #{staff_indexer_status_list}\n\n"
        puts "location_indexer_status_uniq_count: #{location_indexer_status_uniq_count}"
        puts "location_indexer_status_list: #{location_indexer_status_list}\n\n"
        puts "domain_status_uniq_count: #{domain_status_uniq_count}"
        puts "domain_status_list: #{domain_status_list}\n\n"
        puts "staffer_status_uniq_count: #{staffer_status_uniq_count}"
        puts "staffer_status_list: #{staffer_status_list}\n\n"
        puts "geo_status_uniq_count: #{geo_status_uniq_count}"
        puts "geo_status_list: #{geo_status_list}\n\n"
        puts "who_status_uniq_count: #{who_status_uniq_count}"
        puts "who_status_list: #{who_status_list}\n\n"

        ### ==!= CORE CRM BASICS (Uniq) COUNTS === ###
        sfdc_acct_uniq_count = Core.all.map(&:sfdc_acct).uniq.count
        sfdc_id_uniq_count = Core.all.map(&:sfdc_id).uniq.count
        crm_acct_pin_uniq_count = Core.all.map(&:crm_acct_pin).uniq.count
        sfdc_ph_uniq_count = Core.all.map(&:sfdc_ph).uniq.count
        crm_phone_uniq_count = Core.all.map(&:crm_phone).uniq.count
        puts "sfdc_acct_uniq_count: #{sfdc_acct_uniq_count}"
        puts "sfdc_id_uniq_count: #{sfdc_id_uniq_count}"
        puts "crm_acct_pin_uniq_count: #{crm_acct_pin_uniq_count}"
        puts "sfdc_ph_uniq_count: #{sfdc_ph_uniq_count}"
        puts "crm_phone_uniq_count: #{crm_phone_uniq_count}"

        ### ==== CORE CRM ADDRESS (Uniq) COUNTS === ###
        full_address_uniq_count = Core.all.map(&:full_address).uniq.count
        sfdc_street_uniq_count = Core.all.map(&:sfdc_street).uniq.count
        sfdc_city_uniq_count = Core.all.map(&:sfdc_city).uniq.count
        sfdc_state_uniq_count = Core.all.map(&:sfdc_state).uniq.count
        sfdc_zip_uniq_count = Core.all.map(&:sfdc_zip).uniq.count
        puts "full_address_uniq_count: #{full_address_uniq_count}"
        puts "sfdc_street_uniq_count: #{sfdc_street_uniq_count}"
        puts "sfdc_city_uniq_count: #{sfdc_city_uniq_count}"
        puts "sfdc_state_uniq_count: #{sfdc_state_uniq_count}"
        puts "sfdc_zip_uniq_count: #{sfdc_zip_uniq_count}"

        ### === CORE CRM DIGITAL (Uniq) COUNTS === ###
        sfdc_url_uniq_count = Core.all.map(&:sfdc_url).uniq.count
        sfdc_clean_url_uniq_count = Core.all.map(&:sfdc_clean_url).uniq.count
        staff_link_uniq_count = Core.all.map(&:staff_link).uniq.count
        staff_text_uniq_count = Core.all.map(&:staff_text).uniq.count
        location_link_uniq_count = Core.all.map(&:location_link).uniq.count
        location_text_uniq_count = Core.all.map(&:location_text).uniq.count
        sfdc_template_uniq_count = Core.all.map(&:sfdc_template).uniq.count
        sfdc_franchise_uniq_count = Core.all.map(&:sfdc_franchise).uniq.count
        sfdc_franch_cat_uniq_count = Core.all.map(&:sfdc_franch_cat).uniq.count
        acct_source_uniq_count = Core.all.map(&:acct_source).uniq.count
        sfdc_franch_cons_uniq_count = Core.all.map(&:sfdc_franch_cons).uniq.count
        puts "sfdc_url_uniq_count: #{sfdc_url_uniq_count}"
        puts "sfdc_clean_url_uniq_count: #{sfdc_clean_url_uniq_count}"
        puts "staff_link_uniq_count: #{staff_link_uniq_count}"
        puts "staff_text_uniq_count: #{staff_text_uniq_count}"
        puts "location_link_uniq_count: #{location_link_uniq_count}"
        puts "location_text_uniq_count: #{location_text_uniq_count}"
        puts "sfdc_template_uniq_count: #{sfdc_template_uniq_count}"
        puts "sfdc_franchise_uniq_count: #{sfdc_franchise_uniq_count}"
        puts "sfdc_franch_cat_uniq_count: #{sfdc_franch_cat_uniq_count}"
        puts "acct_source_uniq_count: #{acct_source_uniq_count}"
        puts "sfdc_franch_cons_uniq_count: #{sfdc_franch_cons_uniq_count}"

        ### === EXTRA GEO / CORE (uniq) ACCOUNT STUFF === ###
        sfdc_tier_uniq_count = Core.all.map(&:sfdc_tier).uniq.count
        sfdc_sales_person_uniq_count = Core.all.map(&:sfdc_sales_person).uniq.count
        sfdc_type_uniq_count = Core.all.map(&:sfdc_type).uniq.count
        sfdc_ult_grp_uniq_count = Core.all.map(&:sfdc_ult_grp).uniq.count
        sfdc_group_uniq_count = Core.all.map(&:sfdc_group).uniq.count
        temporary_id_uniq_count = Core.all.map(&:temporary_id).uniq.count
        geo_acct_name_uniq_count = Core.all.map(&:geo_acct_name).uniq.count
        cop_coordinates_uniq_count = Core.all.map(&:cop_coordinates).uniq.count
        cop_template_uniq_count = Core.all.map(&:cop_template).uniq.count
        cop_franch_uniq_count = Core.all.map(&:cop_franch).uniq.count
        conf_cat_uniq_count = Core.all.map(&:conf_cat).uniq.count
        sfdc_acct_url_uniq_count = Core.all.map(&:sfdc_acct_url).uniq.count
        sfdc_ult_grp_id_uniq_count = Core.all.map(&:sfdc_ult_grp_id).uniq.count
        sfdc_group_id_uniq_count = Core.all.map(&:sfdc_group_id).uniq.count
        img_url_uniq_count = Core.all.map(&:img_url).uniq.count
        sfdc_ult_rt_uniq_count = Core.all.map(&:sfdc_ult_rt).uniq.count
        sfdc_grp_rt_uniq_count = Core.all.map(&:sfdc_grp_rt).uniq.count
        puts "sfdc_tier_uniq_count: #{sfdc_tier_uniq_count}"
        puts "sfdc_sales_person_uniq_count: #{sfdc_sales_person_uniq_count}"
        puts "sfdc_type_uniq_count: #{sfdc_type_uniq_count}"
        puts "sfdc_ult_grp_uniq_count: #{sfdc_ult_grp_uniq_count}"
        puts "sfdc_group_uniq_count: #{sfdc_group_uniq_count}"
        puts "temporary_id_uniq_count: #{temporary_id_uniq_count}"
        puts "geo_acct_name_uniq_count: #{geo_acct_name_uniq_count}"
        puts "cop_coordinates_uniq_count: #{cop_coordinates_uniq_count}"
        puts "cop_template_uniq_count: #{cop_template_uniq_count}"
        puts "cop_franch_uniq_count: #{cop_franch_uniq_count}"
        puts "conf_cat_uniq_count: #{conf_cat_uniq_count}"
        puts "sfdc_acct_url_uniq_count: #{sfdc_acct_url_uniq_count}"
        puts "sfdc_ult_grp_id_uniq_count: #{sfdc_ult_grp_id_uniq_count}"
        puts "sfdc_group_id_uniq_count: #{sfdc_group_id_uniq_count}"
        puts "img_url_uniq_count: #{img_url_uniq_count}"
        puts "sfdc_ult_rt_uniq_count: #{sfdc_ult_rt_uniq_count}"
        puts "sfdc_grp_rt_uniq_count: #{sfdc_grp_rt_uniq_count}"


        ### === CORE GEO / COP (Uniq) ADDRESS COUNTS === ###
        latitude_uniq_count = Core.all.map(&:latitude).uniq.count
        longitude_uniq_count = Core.all.map(&:longitude).uniq.count
        coordinates_uniq_count = Core.all.map(&:coordinates).uniq.count
        geo_full_address_uniq_count = Core.all.map(&:geo_full_address).uniq.count
        web_acct_pin_uniq_count = Core.all.map(&:web_acct_pin).uniq.count
        cop_lat_uniq_count = Core.all.map(&:cop_lat).uniq.count
        cop_lon_uniq_count = Core.all.map(&:cop_lon).uniq.count
        geo_street_uniq_count = Core.all.map(&:geo_street).uniq.count
        geo_city_uniq_count = Core.all.map(&:geo_city).uniq.count
        geo_state_uniq_count = Core.all.map(&:geo_state).uniq.count
        geo_zip_uniq_count = Core.all.map(&:geo_zip).uniq.count
        geo_ph_uniq_count = Core.all.map(&:geo_ph).uniq.count
        geo_url_uniq_count = Core.all.map(&:geo_url).uniq.count
        puts "latitude_uniq_count: #{latitude_uniq_count}"
        puts "longitude_uniq_count: #{longitude_uniq_count}"
        puts "coordinates_uniq_count: #{coordinates_uniq_count}"
        puts "geo_full_address_uniq_count: #{geo_full_address_uniq_count}"
        puts "web_acct_pin_uniq_count: #{web_acct_pin_uniq_count}"
        puts "cop_lat_uniq_count: #{cop_lat_uniq_count}"
        puts "cop_lon_uniq_count: #{cop_lon_uniq_count}"
        puts "geo_street_uniq_count: #{geo_street_uniq_count}"
        puts "geo_city_uniq_count: #{geo_city_uniq_count}"
        puts "geo_state_uniq_count: #{geo_state_uniq_count}"
        puts "geo_zip_uniq_count: #{geo_zip_uniq_count}"
        puts "geo_ph_uniq_count: #{geo_ph_uniq_count}"
        puts "geo_url_uniq_count: #{geo_url_uniq_count}"


        ##########################################
        ### === TOTALS (not uniq)! === ###
        cores_total = Core.count
        bds_status_total = Core.all.map(&:bds_status).count
        acct_merge_stat_total = Core.all.map(&:acct_merge_stat).count
        acct_merge_stat_dt_total = Core.all.map(&:acct_merge_stat_dt).count
        cont_merge_stat_total = Core.all.map(&:cont_merge_stat).count
        cont_merge_stat_dt_total = Core.all.map(&:cont_merge_stat_dt).count
        staff_indexer_status_total = Core.all.map(&:staff_indexer_status).count
        location_indexer_status_total = Core.all.map(&:location_indexer_status).count
        domain_status_total = Core.all.map(&:domain_status).count
        staffer_status_total = Core.all.map(&:staffer_status).count
        geo_status_total = Core.all.map(&:geo_status).count
        who_status_total = Core.all.map(&:who_status).count

        puts "\n\n\n============ (Core [Totals] Status Counts) ============\n"
        puts "cores_total: #{cores_total}"
        puts "bds_status_total: #{bds_status_total}\n\n"
        puts "acct_merge_stat_total: #{acct_merge_stat_total}"
        puts "acct_merge_stat_dt_total: #{acct_merge_stat_dt_total}"
        puts "cont_merge_stat_total: #{cont_merge_stat_total}"
        puts "cont_merge_stat_dt_total: #{cont_merge_stat_dt_total}"
        puts "staff_indexer_status_total: #{staff_indexer_status_total}"
        puts "location_indexer_status_total: #{location_indexer_status_total}"
        puts "domain_status_total: #{domain_status_total}"
        puts "staffer_status_total: #{staffer_status_total}"
        puts "geo_status_total: #{geo_status_total}"
        puts "who_status_total: #{who_status_total}"

        ### ==!!!!= CORE CRM BASICS (totals) COUNTS === ###
        sfdc_acct_total = Core.all.map(&:sfdc_acct).count
        sfdc_id_total = Core.all.map(&:sfdc_id).count
        crm_acct_pin_total = Core.all.map(&:crm_acct_pin).count
        sfdc_ph_total = Core.all.map(&:sfdc_ph).count
        crm_phone_total = Core.all.map(&:crm_phone).count
        puts "sfdc_acct_total: #{sfdc_acct_total}"
        puts "sfdc_id_total: #{sfdc_id_total}"
        puts "crm_acct_pin_total: #{crm_acct_pin_total}"
        puts "sfdc_ph_total: #{sfdc_ph_total}"
        puts "crm_phone_total: #{crm_phone_total}"

        ### =!!!!== CORE CRM ADDRESS (totals) COUNTS === ###
        full_address_total = Core.all.map(&:full_address).count
        sfdc_street_total = Core.all.map(&:sfdc_street).count
        sfdc_city_total = Core.all.map(&:sfdc_city).count
        sfdc_state_total = Core.all.map(&:sfdc_state).count
        sfdc_zip_total = Core.all.map(&:sfdc_zip).count
        puts "full_address_total: #{full_address_total}"
        puts "sfdc_street_total: #{sfdc_street_total}"
        puts "sfdc_city_total: #{sfdc_city_total}"
        puts "sfdc_state_total: #{sfdc_state_total}"
        puts "sfdc_zip_total: #{sfdc_zip_total}"

        ### ==!!!= CORE CRM DIGITAL (totals) COUNTS === ###
        sfdc_url_total = Core.all.map(&:sfdc_url).count
        sfdc_clean_url_total = Core.all.map(&:sfdc_clean_url).count
        staff_link_total = Core.all.map(&:staff_link).count
        staff_text_total = Core.all.map(&:staff_text).count
        location_link_total = Core.all.map(&:location_link).count
        location_text_total = Core.all.map(&:location_text).count
        sfdc_template_total = Core.all.map(&:sfdc_template).count
        sfdc_franchise_total = Core.all.map(&:sfdc_franchise).count
        sfdc_franch_cat_total = Core.all.map(&:sfdc_franch_cat).count
        acct_source_total = Core.all.map(&:acct_source).count
        sfdc_franch_cons_total = Core.all.map(&:sfdc_franch_cons).count
        puts "sfdc_url_total: #{sfdc_url_total}"
        puts "sfdc_clean_url_total: #{sfdc_clean_url_total}"
        puts "staff_link_total: #{staff_link_total}"
        puts "staff_text_total: #{staff_text_total}"
        puts "location_link_total: #{location_link_total}"
        puts "location_text_total: #{location_text_total}"
        puts "sfdc_template_total: #{sfdc_template_total}"
        puts "sfdc_franchise_total: #{sfdc_franchise_total}"
        puts "sfdc_franch_cat_total: #{sfdc_franch_cat_total}"
        puts "acct_source_total: #{acct_source_total}"
        puts "sfdc_franch_cons_total: #{sfdc_franch_cons_total}"

        ### ==!!!!= EXTRA GEO / CORE (total) ACCOUNT STUFF === ###
        sfdc_tier_total = Core.all.map(&:sfdc_tier).count
        sfdc_sales_person_total = Core.all.map(&:sfdc_sales_person).count
        sfdc_type_total = Core.all.map(&:sfdc_type).count
        sfdc_ult_grp_total = Core.all.map(&:sfdc_ult_grp).count
        sfdc_group_total = Core.all.map(&:sfdc_group).count
        temporary_id_total = Core.all.map(&:temporary_id).count
        geo_acct_name_total = Core.all.map(&:geo_acct_name).count
        cop_coordinates_total = Core.all.map(&:cop_coordinates).count
        cop_template_total = Core.all.map(&:cop_template).count
        cop_franch_total = Core.all.map(&:cop_franch).count
        conf_cat_total = Core.all.map(&:conf_cat).count
        sfdc_acct_url_total = Core.all.map(&:sfdc_acct_url).count
        sfdc_ult_grp_id_total = Core.all.map(&:sfdc_ult_grp_id).count
        sfdc_group_id_total = Core.all.map(&:sfdc_group_id).count
        img_url_total = Core.all.map(&:img_url).count
        sfdc_ult_rt_total = Core.all.map(&:sfdc_ult_rt).count
        sfdc_grp_rt_total = Core.all.map(&:sfdc_grp_rt).count
        puts "sfdc_tier_total: #{sfdc_tier_total}"
        puts "sfdc_sales_person_total: #{sfdc_sales_person_total}"
        puts "sfdc_type_total: #{sfdc_type_total}"
        puts "sfdc_ult_grp_total: #{sfdc_ult_grp_total}"
        puts "sfdc_group_total: #{sfdc_group_total}"
        puts "temporary_id_total: #{temporary_id_total}"
        puts "geo_acct_name_total: #{geo_acct_name_total}"
        puts "cop_coordinates_total: #{cop_coordinates_total}"
        puts "cop_template_total: #{cop_template_total}"
        puts "cop_franch_total: #{cop_franch_total}"
        puts "conf_cat_total: #{conf_cat_total}"
        puts "sfdc_acct_url_total: #{sfdc_acct_url_total}"
        puts "sfdc_ult_grp_id_total: #{sfdc_ult_grp_id_total}"
        puts "sfdc_group_id_total: #{sfdc_group_id_total}"
        puts "img_url_total: #{img_url_total}"
        puts "sfdc_ult_rt_total: #{sfdc_ult_rt_total}"
        puts "sfdc_grp_rt_total: #{sfdc_grp_rt_total}"

        ### ==!!!= CORE GEO / COP (Totals) ADDRESS COUNTS === ###
        latitude_total = Core.all.map(&:latitude).count
        longitude_total = Core.all.map(&:longitude).count
        coordinates_total = Core.all.map(&:coordinates).count
        geo_full_address_total = Core.all.map(&:geo_full_address).count
        web_acct_pin_total = Core.all.map(&:web_acct_pin).count
        cop_lat_total = Core.all.map(&:cop_lat).count
        cop_lon_total = Core.all.map(&:cop_lon).count
        geo_street_total = Core.all.map(&:geo_street).count
        geo_city_total = Core.all.map(&:geo_city).count
        geo_state_total = Core.all.map(&:geo_state).count
        geo_zip_total = Core.all.map(&:geo_zip).count
        geo_ph_total = Core.all.map(&:geo_ph).count
        geo_url_total = Core.all.map(&:geo_url).count
        puts "latitude_total: #{latitude_total}"
        puts "longitude_total: #{longitude_total}"
        puts "coordinates_total: #{coordinates_total}"
        puts "geo_full_address_total: #{geo_full_address_total}"
        puts "web_acct_pin_total: #{web_acct_pin_total}"
        puts "cop_lat_total: #{cop_lat_total}"
        puts "cop_lon_total: #{cop_lon_total}"
        puts "geo_street_total: #{geo_street_total}"
        puts "geo_city_total: #{geo_city_total}"
        puts "geo_state_total: #{geo_state_total}"
        puts "geo_zip_total: #{geo_zip_total}"
        puts "geo_ph_total: #{geo_ph_total}"
        puts "geo_url_total: #{geo_url_total}"

    end


    ## 2. Contacts ReCalc Method
    def staffers_dash
        staffers_total = Staffer.count

        ### === UNIQ COUNTS! === ###
        staffer_status_uniq_count = Staffer.all.map(&:staffer_status).uniq.count
        cont_status_uniq_count = Staffer.all.map(&:cont_status).uniq.count

        staffer_status_list = Staffer.all.map(&:staffer_status).uniq
        cont_status_list = Staffer.all.map(&:cont_status).uniq

        cont_source_uniq_count = Staffer.all.map(&:cont_source).uniq.count
        acct_pin_uniq_count = Staffer.all.map(&:acct_pin).uniq.count
        cont_pin_uniq_count = Staffer.all.map(&:cont_pin).uniq.count
        sfdc_id_uniq_count = sfdc_id = Staffer.all.map(&:sfdc_id).uniq.count
        acct_name_uniq_count = Staffer.all.map(&:acct_name).uniq.count
        email_uniq_count = Staffer.all.map(&:email).uniq.count
        sfdc_sales_person_uniq_count = Staffer.all.map(&:sfdc_sales_person).uniq.count
        sfdc_type_uniq_count = Staffer.all.map(&:sfdc_type).uniq.count
        sfdc_cont_id_uniq_count = Staffer.all.map(&:sfdc_cont_id).uniq.count
        sfdc_tier_uniq_count = Staffer.all.map(&:sfdc_tier).uniq.count
        domain_uniq_count = Staffer.all.map(&:domain).uniq.count
        fname_uniq_count = Staffer.all.map(&:fname).uniq.count
        lname_uniq_count = Staffer.all.map(&:lname).uniq.count
        fullname_uniq_count = Staffer.all.map(&:fullname).uniq.count
        job_uniq_count = Staffer.all.map(&:job).uniq.count
        job_raw_uniq_count = Staffer.all.map(&:job_raw).uniq.count
        phone_uniq_count = Staffer.all.map(&:phone).uniq.count

        puts "\n\n\n============ (Staffers (UNIQ) Counts) ============\n"
        puts "staffers_total: #{staffers_total}"
        puts "staffer_status_uniq_count: #{staffer_status_uniq_count}"
        puts "staffer_status_list: #{staffer_status_list}"
        puts "cont_status_list: #{cont_status_list}"
        puts "cont_status_uniq_count: #{cont_status_uniq_count}"
        puts "job_uniq_count: #{job_uniq_count}"
        puts "job_raw_uniq_count: #{job_raw_uniq_count}"
        puts "domain_uniq_count: #{domain_uniq_count}"
        puts "cont_source_uniq_count: #{cont_source_uniq_count}"
        puts "acct_pin_uniq_count: #{acct_pin_uniq_count}"
        puts "cont_pin_uniq_count: #{cont_pin_uniq_count}"
        puts "sfdc_id_uniq_count: #{sfdc_id_uniq_count}"
        puts "acct_name_uniq_count: #{acct_name_uniq_count}"
        puts "email_uniq_count: #{email_uniq_count}"
        puts "sfdc_sales_person_uniq_count: #{sfdc_sales_person_uniq_count}"
        puts "sfdc_type_uniq_count: #{sfdc_type_uniq_count}"
        puts "sfdc_cont_id_uniq_count: #{sfdc_cont_id_uniq_count}"
        puts "sfdc_tier_uniq_count: #{sfdc_tier_uniq_count}"
        puts "fname_uniq_count: #{fname_uniq_count}"
        puts "lname_uniq_count: #{lname_uniq_count}"
        puts "fullname_uniq_count: #{fullname_uniq_count}"
        puts "phone_uniq_count: #{phone_uniq_count}"

        ##########################################
        ### === TOTALS (not uniq)! === ###

        staffer_status_total = Staffer.all.map(&:staffer_status).count
        cont_status_total = Staffer.all.map(&:cont_status).count
        cont_source_total = Staffer.all.map(&:cont_source).count
        acct_pin_total = Staffer.all.map(&:acct_pin).count
        cont_pin_total = Staffer.all.map(&:cont_pin).count
        sfdc_id_total = sfdc_id = Staffer.all.map(&:sfdc_id).count
        acct_name_total = Staffer.all.map(&:acct_name).count
        email_total = Staffer.all.map(&:email).count.count
        sfdc_sales_person_total = Staffer.all.map(&:sfdc_sales_person).count
        sfdc_type_total = Staffer.all.map(&:sfdc_type).count
        sfdc_cont_id_total = Staffer.all.map(&:sfdc_cont_id).count
        sfdc_tier_total = Staffer.all.map(&:sfdc_tier).count
        domain_total = Staffer.all.map(&:domain).count
        fname_total = Staffer.all.map(&:fname).count
        lname_total = Staffer.all.map(&:lname).count
        fullname_total = Staffer.all.map(&:fullname).count
        job_total = Staffer.all.map(&:job).count
        job_raw_total = Staffer.all.map(&:job_raw).count
        phone_total = Staffer.all.map(&:phone).count

        puts "\n\n\n============ (Staffers [Totals] Counts) ============\n"
        puts "staffers_total: #{staffers_total}"
        puts "staffer_status_total: #{staffer_status_total}"
        puts "cont_status_total: #{cont_status_total}"
        puts "job_total: #{job_total}"
        puts "job_raw_total: #{job_raw_total}"
        puts "domain_total: #{domain_total}"
        puts "cont_source_total: #{cont_source_total}"
        puts "acct_pin_total: #{acct_pin_total}"
        puts "cont_pin_total: #{cont_pin_total}"
        puts "sfdc_id_total: #{sfdc_id_total}"
        puts "acct_name_total: #{acct_name_total}"
        puts "email_total: #{email_total}"
        puts "sfdc_sales_person_total: #{sfdc_sales_person_total}"
        puts "sfdc_type_total: #{sfdc_type_total}"
        puts "sfdc_cont_id_total: #{sfdc_cont_id_total}"
        puts "sfdc_tier_total: #{sfdc_tier_total}"
        puts "fname_total: #{fname_total}"
        puts "lname_total: #{lname_total}"
        puts "fullname_total: #{fullname_total}"
        puts "phone_total: #{phone_total}"
    end


    ## 3. Crone Jobs ReCalc Method
    ### ERROR!!! - NOT RUNNING
    def delayed_jobs_dash
        # delayed_jobs_total = DelayedJob.count
        # priority_uniq_count = DelayedJob.all.map(&:priority).uniq.count
        # attempts_uniq_count = DelayedJob.all.map(&:attempts).uniq.count
        # handler_uniq_count = DelayedJob.all.map(&:handler).uniq.count
        # last_error_uniq_count = DelayedJob.all.map(&:last_error).uniq.count
        # run_at_uniq_count = DelayedJob.all.map(&:run_at).uniq.count
        # locked_at_uniq_count = DelayedJob.all.map(&:locked_at).uniq.count
        # failed_at_uniq_count = DelayedJob.all.map(&:failed_at).uniq.count
        # locked_by_uniq_count = DelayedJob.all.map(&:locked_by).uniq.count
        # queue_uniq_count = DelayedJob.all.map(&:queue).uniq.count
        # created_at_uniq_count = DelayedJob.all.map(&:created_at).uniq.count
        # updated_at_uniq_count = DelayedJob.all.map(&:updated_at).uniq.count
        #
        # puts "\n\n============ (Delayed Jobs Counts) ============\n"
        # puts "delayed_jobs_total: #{delayed_jobs_total}"
        # puts "priority_uniq_count: #{priority_uniq_count}"
        # puts "attempts_uniq_count: #{attempts_uniq_count}"
        # puts "handler_uniq_count: #{handler_uniq_count}"
        # puts "last_error_uniq_count: #{last_error_uniq_count}"
        # puts "run_at_uniq_count: #{run_at_uniq_count}"
        # puts "locked_at_uniq_count: #{locked_at_uniq_count}"
        # puts "failed_at_uniq_count: #{failed_at_uniq_count}"
        # puts "locked_by_uniq_count: #{locked_by_uniq_count}"
        # puts "queue_uniq_count: #{queue_uniq_count}"
        # puts "created_at_uniq_count: #{created_at_uniq_count}"
        # puts "updated_at_uniq_count: #{updated_at_uniq_count}"
    end


    ## 4. Franchise ReCalc Method
    def franchise_dash
        franchise_total = InHostPo.count

        ### === UNIQ COUNTS! === ###
        term_uniq_count = InHostPo.all.map(&:term).uniq.count
        consolidated_term_uniq_count = InHostPo.all.map(&:consolidated_term).uniq.count
        category_uniq_count = InHostPo.all.map(&:category).uniq.count

        puts "\n\n============ (Franchise (UNIQ) Counts) ============\n"
        puts "franchise_total: #{franchise_total}"
        puts "term_uniq_count: #{term_uniq_count}"
        puts "consolidated_term_uniq_count: #{consolidated_term_uniq_count}"
        puts "category_uniq_count: #{category_uniq_count}"

        ##########################################
        ### === TOTALS (not uniq)! === ###
        term_total = InHostPo.all.map(&:term).count
        consolidated_term_total = InHostPo.all.map(&:consolidated_term).count
        category_total = InHostPo.all.map(&:category).count

        puts "\n\n============ (Franchise [Totals] Counts) ============\n"
        puts "franchise_total: #{franchise_total}"
        puts "term_total: #{term_total}"
        puts "consolidated_term_total: #{consolidated_term_total}"
        puts "category_total: #{category_total}"

    end


    ## 5. GeoLocations ReCalc Method
    def geo_locations_dash
        location_total = Location.count

        ### === UNIQ-Lists COUNTS! === ###
        location_status_list = Location.all.map(&:location_status).uniq
        sts_geo_crm_list = Location.all.map(&:sts_geo_crm).uniq
        sts_url_list = Location.all.map(&:sts_url).uniq
        sts_root_list = Location.all.map(&:sts_root).uniq
        sts_acct_list = Location.all.map(&:sts_acct).uniq
        sts_addr_list = Location.all.map(&:sts_addr).uniq
        sts_ph_list = Location.all.map(&:sts_ph).uniq
        sts_duplicate_list = Location.all.map(&:sts_duplicate).uniq
        url_sts_list = Location.all.map(&:url_sts).uniq
        acct_sts_list = Location.all.map(&:acct_sts).uniq
        addr_sts_list = Location.all.map(&:addr_sts).uniq
        ph_sts_list = Location.all.map(&:ph_sts).uniq

        puts "\n\n============ (GeoLocation (UNIQ-Lists) Counts) ============\n"
        puts "location_status_list: #{location_status_list}"
        puts "sts_geo_crm_list: #{sts_geo_crm_list}"
        puts "sts_url_list: #{sts_url_list}"
        puts "sts_root_list: #{sts_root_list}"
        puts "sts_acct_list: #{sts_acct_list}"
        puts "sts_addr_list: #{sts_addr_list}"
        puts "sts_ph_list: #{sts_ph_list}"
        puts "sts_duplicate_list: #{sts_duplicate_list}"
        puts "url_sts_list: #{url_sts_list}"
        puts "acct_sts_list: #{acct_sts_list}"
        puts "addr_sts_list: #{addr_sts_list}"
        puts "ph_sts_list: #{ph_sts_list}\n\n"

        ### === UNIQ COUNTS! === ###
        location_status_uniq_count = Location.all.map(&:location_status).uniq.count
        sts_geo_crm_uniq_count = Location.all.map(&:sts_geo_crm).uniq.count
        sts_url_uniq_count = Location.all.map(&:sts_url).uniq.count
        sts_root_uniq_count = Location.all.map(&:sts_root).uniq.count
        sts_acct_uniq_count = Location.all.map(&:sts_acct).uniq.count
        sts_addr_uniq_count = Location.all.map(&:sts_addr).uniq.count
        sts_ph_uniq_count = Location.all.map(&:sts_ph).uniq.count
        sts_duplicate_uniq_count = Location.all.map(&:sts_duplicate).uniq.count
        url_sts_uniq_count = Location.all.map(&:url_sts).uniq.count
        acct_sts_uniq_count = Location.all.map(&:acct_sts).uniq.count
        addr_sts_uniq_count = Location.all.map(&:addr_sts).uniq.count
        ph_sts_uniq_count = Location.all.map(&:ph_sts).uniq.count

        latitude_uniq_count = Location.all.map(&:latitude).uniq.count
        longitude_uniq_count = Location.all.map(&:longitude).uniq.count
        city_uniq_count = Location.all.map(&:city).uniq.count
        state_uniq_count = Location.all.map(&:state).uniq.count
        state_code_uniq_count = Location.all.map(&:state_code).uniq.count
        postal_code_uniq_count = Location.all.map(&:postal_code).uniq.count
        coordinates_uniq_count = Location.all.map(&:coordinates).uniq.count
        acct_name_uniq_count = Location.all.map(&:acct_name).uniq.count
        group_name_uniq_count = Location.all.map(&:group_name).uniq.count
        ult_group_name_uniq_count = Location.all.map(&:ult_group_name).uniq.count
        source_uniq_count = Location.all.map(&:source).uniq.count
        sfdc_id_uniq_count = Location.all.map(&:sfdc_id).uniq.count
        tier_uniq_count = Location.all.map(&:tier).uniq.count
        sales_person_uniq_count = Location.all.map(&:sales_person).uniq.count
        acct_type_uniq_count = Location.all.map(&:acct_type).uniq.count
        url_uniq_count = Location.all.map(&:url).uniq.count
        street_uniq_count = Location.all.map(&:street).uniq.count
        address_uniq_count = Location.all.map(&:address).uniq.count
        temporary_id_uniq_count = Location.all.map(&:temporary_id).uniq.count
        geo_acct_name_uniq_count = Location.all.map(&:geo_acct_name).uniq.count
        geo_full_addr_uniq_count = Location.all.map(&:geo_full_addr).uniq.count
        phone_uniq_count = Location.all.map(&:phone).uniq.count
        map_url_uniq_count = Location.all.map(&:map_url).uniq.count
        img_url_uniq_count = Location.all.map(&:img_url).uniq.count
        place_id_uniq_count = Location.all.map(&:place_id).uniq.count
        crm_source_uniq_count = Location.all.map(&:crm_source).uniq.count
        geo_root_uniq_count = Location.all.map(&:geo_root).uniq.count
        crm_root_uniq_count = Location.all.map(&:crm_root).uniq.count
        crm_url_uniq_count = Location.all.map(&:crm_url).uniq.count
        geo_franch_term_uniq_count = Location.all.map(&:geo_franch_term).uniq.count
        geo_franch_cons_uniq_count = Location.all.map(&:geo_franch_cons).uniq.count
        geo_franch_cat_uniq_count = Location.all.map(&:geo_franch_cat).uniq.count
        crm_franch_term_uniq_count = Location.all.map(&:crm_franch_term).uniq.count
        crm_franch_cons_uniq_count = Location.all.map(&:crm_franch_cons).uniq.count
        crm_franch_cat_uniq_count = Location.all.map(&:crm_franch_cat).uniq.count
        crm_phone_uniq_count = Location.all.map(&:crm_phone).uniq.count
        geo_type_uniq_count = Location.all.map(&:geo_type).uniq.count
        coord_id_arr_uniq_count = Location.all.map(&:coord_id_arr).uniq.count
        sfdc_acct_url_uniq_count = Location.all.map(&:sfdc_acct_url).uniq.count
        street_num_uniq_count = Location.all.map(&:street_num).uniq.count
        street_text_uniq_count = Location.all.map(&:street_text).uniq.count
        crm_street_uniq_count = Location.all.map(&:crm_street).uniq.count
        crm_city_uniq_count = Location.all.map(&:crm_city).uniq.count
        crm_state_uniq_count = Location.all.map(&:crm_state).uniq.count
        crm_zip_uniq_count = Location.all.map(&:crm_zip).uniq.count
        crm_url_redirect_uniq_count = Location.all.map(&:crm_url_redirect).uniq.count
        geo_url_redirect_uniq_count = Location.all.map(&:geo_url_redirect).uniq.count
        url_arr_uniq_count = Location.all.map(&:url_arr).uniq.count
        duplicate_arr_uniq_count = Location.all.map(&:duplicate_arr).uniq.count
        cop_franch_arr_uniq_count = Location.all.map(&:cop_franch_arr).uniq.count
        cop_franch_uniq_count = Location.all.map(&:cop_franch).uniq.count
        sfdc_acct_pin_uniq_count = Location.all.map(&:sfdc_acct_pin).uniq.count
        geo_acct_pin_uniq_count = Location.all.map(&:geo_acct_pin).uniq.count

        puts "\n\n============ (GeoLocation (UNIQ) Counts) ============\n"
        puts "location_total: #{location_total}"
        puts "location_status_uniq_count: #{location_status_uniq_count}"
        puts "sts_geo_crm_uniq_count: #{sts_geo_crm_uniq_count}"
        puts "sts_url_uniq_count: #{sts_url_uniq_count}"
        puts "sts_root_uniq_count: #{sts_root_uniq_count}"
        puts "sts_acct_uniq_count: #{sts_acct_uniq_count}"
        puts "sts_addr_uniq_count: #{sts_addr_uniq_count}"
        puts "sts_ph_uniq_count: #{sts_ph_uniq_count}"
        puts "sts_duplicate_uniq_count: #{sts_duplicate_uniq_count}"
        puts "url_sts_uniq_count: #{url_sts_uniq_count}"
        puts "acct_sts_uniq_count: #{acct_sts_uniq_count}"
        puts "addr_sts_uniq_count: #{addr_sts_uniq_count}"
        puts "ph_sts_uniq_count: #{ph_sts_uniq_count}\n\n"
        puts "latitude_uniq_count: #{latitude_uniq_count}"
        puts "longitude_uniq_count: #{longitude_uniq_count}"
        puts "city_uniq_count: #{city_uniq_count}"
        puts "state_uniq_count: #{state_uniq_count}"
        puts "state_code_uniq_count: #{state_code_uniq_count}"
        puts "postal_code_uniq_count: #{postal_code_uniq_count}"
        puts "coordinates_uniq_count: #{coordinates_uniq_count}"
        puts "acct_name_uniq_count: #{acct_name_uniq_count}"
        puts "group_name_uniq_count: #{group_name_uniq_count}"
        puts "ult_group_name_uniq_count: #{ult_group_name_uniq_count}"
        puts "source_uniq_count: #{source_uniq_count}"
        puts "sfdc_id_uniq_count: #{sfdc_id_uniq_count}"
        puts "tier_uniq_count: #{tier_uniq_count}"
        puts "sales_person_uniq_count: #{sales_person_uniq_count}"
        puts "acct_type_uniq_count: #{acct_type_uniq_count}"
        puts "url_uniq_count: #{url_uniq_count}"
        puts "street_uniq_count: #{street_uniq_count}"
        puts "address_uniq_count: #{address_uniq_count}"
        puts "temporary_id_uniq_count: #{temporary_id_uniq_count}"
        puts "geo_acct_name_uniq_count: #{geo_acct_name_uniq_count}"
        puts "geo_full_addr_uniq_count: #{geo_full_addr_uniq_count}"
        puts "phone_uniq_count: #{phone_uniq_count}"
        puts "map_url_uniq_count: #{map_url_uniq_count}"
        puts "img_url_uniq_count: #{img_url_uniq_count}"
        puts "place_id_uniq_count: #{place_id_uniq_count}"
        puts "crm_source_uniq_count: #{crm_source_uniq_count}"
        puts "geo_root_uniq_count: #{geo_root_uniq_count}"
        puts "crm_root_uniq_count: #{crm_root_uniq_count}"
        puts "crm_url_uniq_count: #{crm_url_uniq_count}"
        puts "geo_franch_term_uniq_count: #{geo_franch_term_uniq_count}"
        puts "geo_franch_cons_uniq_count: #{geo_franch_cons_uniq_count}"
        puts "geo_franch_cat_uniq_count: #{geo_franch_cat_uniq_count}"
        puts "crm_franch_term_uniq_count: #{crm_franch_term_uniq_count}"
        puts "crm_franch_cons_uniq_count: #{crm_franch_cons_uniq_count}"
        puts "crm_franch_cat_uniq_count: #{crm_franch_cat_uniq_count}"
        puts "crm_phone_uniq_count: #{crm_phone_uniq_count}"
        puts "geo_type_uniq_count: #{geo_type_uniq_count}"
        puts "coord_id_arr_uniq_count: #{coord_id_arr_uniq_count}"
        puts "sfdc_acct_url_uniq_count: #{sfdc_acct_url_uniq_count}"
        puts "street_num_uniq_count: #{street_num_uniq_count}"
        puts "street_text_uniq_count: #{street_text_uniq_count}"
        puts "crm_street_uniq_count: #{crm_street_uniq_count}"
        puts "crm_city_uniq_count: #{crm_city_uniq_count}"
        puts "crm_state_uniq_count: #{crm_state_uniq_count}"
        puts "crm_zip_uniq_count: #{crm_zip_uniq_count}"
        puts "crm_url_redirect_uniq_count: #{crm_url_redirect_uniq_count}"
        puts "geo_url_redirect_uniq_count: #{geo_url_redirect_uniq_count}"
        puts "url_arr_uniq_count: #{url_arr_uniq_count}"
        puts "duplicate_arr_uniq_count: #{duplicate_arr_uniq_count}"
        puts "cop_franch_arr_uniq_count: #{cop_franch_arr_uniq_count}"
        puts "cop_franch_uniq_count: #{cop_franch_uniq_count}"
        puts "sfdc_acct_pin_uniq_count: #{sfdc_acct_pin_uniq_count}"
        puts "geo_acct_pin_uniq_count: #{geo_acct_pin_uniq_count}"

        ##########################################
        ### === TOTALS (not uniq)! === ###
        location_status_total = Location.all.map(&:location_status).count
        sts_geo_crm_total = Location.all.map(&:sts_geo_crm).count
        sts_url_total = Location.all.map(&:sts_url).count
        sts_root_total = Location.all.map(&:sts_root).count
        sts_acct_total = Location.all.map(&:sts_acct).count
        sts_addr_total = Location.all.map(&:sts_addr).count
        sts_ph_total = Location.all.map(&:sts_ph).count
        sts_duplicate_total = Location.all.map(&:sts_duplicate).count
        url_sts_total = Location.all.map(&:url_sts).count
        acct_sts_total = Location.all.map(&:acct_sts).count
        addr_sts_total = Location.all.map(&:addr_sts).count
        ph_sts_total = Location.all.map(&:ph_sts).count
        latitude_total = Location.all.map(&:latitude).count
        longitude_total = Location.all.map(&:longitude).count
        city_total = Location.all.map(&:city).count
        state_total = Location.all.map(&:state).count
        state_code_total = Location.all.map(&:state_code).count
        postal_code_total = Location.all.map(&:postal_code).count
        coordinates_total = Location.all.map(&:coordinates).count
        acct_name_total = Location.all.map(&:acct_name).count
        group_name_total = Location.all.map(&:group_name).count
        ult_group_name_total = Location.all.map(&:ult_group_name).count
        source_total = Location.all.map(&:source).count
        sfdc_id_total = Location.all.map(&:sfdc_id).count
        tier_total = Location.all.map(&:tier).count
        sales_person_total = Location.all.map(&:sales_person).count
        acct_type_total = Location.all.map(&:acct_type).count
        url_total = Location.all.map(&:url).count
        street_total = Location.all.map(&:street).count
        address_total = Location.all.map(&:address).count
        temporary_id_total = Location.all.map(&:temporary_id).count
        geo_acct_name_total = Location.all.map(&:geo_acct_name).count
        geo_full_addr_total = Location.all.map(&:geo_full_addr).count
        phone_total = Location.all.map(&:phone).count
        map_url_total = Location.all.map(&:map_url).count
        img_url_total = Location.all.map(&:img_url).count
        place_id_total = Location.all.map(&:place_id).count
        crm_source_total = Location.all.map(&:crm_source).count
        geo_root_total = Location.all.map(&:geo_root).count
        crm_root_total = Location.all.map(&:crm_root).count
        crm_url_total = Location.all.map(&:crm_url).count
        geo_franch_term_total = Location.all.map(&:geo_franch_term).count
        geo_franch_cons_total = Location.all.map(&:geo_franch_cons).count
        geo_franch_cat_total = Location.all.map(&:geo_franch_cat).count
        crm_franch_term_total = Location.all.map(&:crm_franch_term).count
        crm_franch_cons_total = Location.all.map(&:crm_franch_cons).count
        crm_franch_cat_total = Location.all.map(&:crm_franch_cat).count
        crm_phone_total = Location.all.map(&:crm_phone).count
        geo_type_total = Location.all.map(&:geo_type).count
        coord_id_arr_total = Location.all.map(&:coord_id_arr).count
        sfdc_acct_url_total = Location.all.map(&:sfdc_acct_url).count
        street_num_total = Location.all.map(&:street_num).count
        street_text_total = Location.all.map(&:street_text).count
        crm_street_total = Location.all.map(&:crm_street).count
        crm_city_total = Location.all.map(&:crm_city).count
        crm_state_total = Location.all.map(&:crm_state).count
        crm_zip_total = Location.all.map(&:crm_zip).count
        crm_url_redirect_total = Location.all.map(&:crm_url_redirect).count
        geo_url_redirect_total = Location.all.map(&:geo_url_redirect).count
        url_arr_total = Location.all.map(&:url_arr).count
        duplicate_arr_total = Location.all.map(&:duplicate_arr).count
        cop_franch_arr_total = Location.all.map(&:cop_franch_arr).count
        cop_franch_total = Location.all.map(&:cop_franch).count
        sfdc_acct_pin_total = Location.all.map(&:sfdc_acct_pin).count
        geo_acct_pin_total = Location.all.map(&:geo_acct_pin).count

        puts "\n\n============ (GeoLocation [Totals] Counts) ============\n"
        puts "location_total: #{location_total}"
        puts "location_status_total: #{location_status_total}"
        puts "sts_geo_crm_total: #{sts_geo_crm_total}"
        puts "sts_url_total: #{sts_url_total}"
        puts "sts_root_total: #{sts_root_total}"
        puts "sts_acct_total: #{sts_acct_total}"
        puts "sts_addr_total: #{sts_addr_total}"
        puts "sts_ph_total: #{sts_ph_total}"
        puts "sts_duplicate_total: #{sts_duplicate_total}"
        puts "url_sts_total: #{url_sts_total}"
        puts "acct_sts_total: #{acct_sts_total}"
        puts "addr_sts_total: #{addr_sts_total}"
        puts "ph_sts_total: #{ph_sts_total}\n\n"

        puts "latitude_total: #{latitude_total}"
        puts "longitude_total: #{longitude_total}"
        puts "city_total: #{city_total}"
        puts "state_total: #{state_total}"
        puts "state_code_total: #{state_code_total}"
        puts "postal_code_total: #{postal_code_total}"
        puts "coordinates_total: #{coordinates_total}"
        puts "acct_name_total: #{acct_name_total}"
        puts "group_name_total: #{group_name_total}"
        puts "ult_group_name_total: #{ult_group_name_total}"
        puts "source_total: #{source_total}"
        puts "sfdc_id_total: #{sfdc_id_total}"
        puts "tier_total: #{tier_total}"
        puts "sales_person_total: #{sales_person_total}"
        puts "acct_type_total: #{acct_type_total}"
        puts "url_total: #{url_total}"
        puts "street_total: #{street_total}"
        puts "address_total: #{address_total}"
        puts "temporary_id_total: #{temporary_id_total}"
        puts "geo_acct_name_total: #{geo_acct_name_total}"
        puts "geo_full_addr_total: #{geo_full_addr_total}"
        puts "phone_total: #{phone_total}"
        puts "map_url_total: #{map_url_total}"
        puts "img_url_total: #{img_url_total}"
        puts "place_id_total: #{place_id_total}"
        puts "crm_source_total: #{crm_source_total}"
        puts "geo_root_total: #{geo_root_total}"
        puts "crm_root_total: #{crm_root_total}"
        puts "crm_url_total: #{crm_url_total}"
        puts "geo_franch_term_total: #{geo_franch_term_total}"
        puts "geo_franch_cons_total: #{geo_franch_cons_total}"
        puts "geo_franch_cat_total: #{geo_franch_cat_total}"
        puts "crm_franch_term_total: #{crm_franch_term_total}"
        puts "crm_franch_cons_total: #{crm_franch_cons_total}"
        puts "crm_franch_cat_total: #{crm_franch_cat_total}"
        puts "crm_phone_total: #{crm_phone_total}"
        puts "geo_type_total: #{geo_type_total}"
        puts "coord_id_arr_total: #{coord_id_arr_total}"
        puts "sfdc_acct_url_total: #{sfdc_acct_url_total}"
        puts "street_num_total: #{street_num_total}"
        puts "street_text_total: #{street_text_total}"
        puts "crm_street_total: #{crm_street_total}"
        puts "crm_city_total: #{crm_city_total}"
        puts "crm_state_total: #{crm_state_total}"
        puts "crm_zip_total: #{crm_zip_total}"
        puts "crm_url_redirect_total: #{crm_url_redirect_total}"
        puts "geo_url_redirect_total: #{geo_url_redirect_total}"
        puts "url_arr_total: #{url_arr_total}"
        puts "duplicate_arr_total: #{duplicate_arr_total}"
        puts "cop_franch_arr_total: #{cop_franch_arr_total}"
        puts "cop_franch_total: #{cop_franch_total}"
        puts "sfdc_acct_pin_total: #{sfdc_acct_pin_total}"
        puts "geo_acct_pin_total: #{geo_acct_pin_total}"

    end


    ## 6. Indexer ReCalc Method
    def indexer_dash
        indexer_total = Indexer.count

        ### === UNIQ LISTS COUNTS! === ###
        redirect_status_list = Indexer.all.map(&:redirect_status).uniq
        indexer_status_list = Indexer.all.map(&:indexer_status).uniq
        who_status_list = Indexer.all.map(&:who_status).uniq
        rt_sts_list = Indexer.all.map(&:rt_sts).uniq
        cont_sts_list = Indexer.all.map(&:cont_sts).uniq
        loc_status_list = Indexer.all.map(&:loc_status).uniq
        stf_status_list = Indexer.all.map(&:stf_status).uniq
        contact_status_list = Indexer.all.map(&:contact_status).uniq

        puts "\n\n============ (Indexer (UNIQ Lists) Counts) ============\n"
        puts "\n\nredirect_status_list: #{redirect_status_list}"
        puts "indexer_status_list: #{indexer_status_list}"
        puts "who_status_list: #{who_status_list}"
        puts "rt_sts_list: #{rt_sts_list}"
        puts "cont_sts_list: #{cont_sts_list}"
        puts "loc_status_list: #{loc_status_list}"
        puts "stf_status_list: #{stf_status_list}"
        puts "contact_status_list: #{contact_status_list}\n\n"

        ### === UNIQ COUNTS! === ###
        redirect_status_uniq_count = Indexer.all.map(&:redirect_status).uniq.count
        indexer_status_uniq_count = Indexer.all.map(&:indexer_status).uniq.count
        who_status_uniq_count = Indexer.all.map(&:who_status).uniq.count
        rt_sts_uniq_count = Indexer.all.map(&:rt_sts).uniq.count
        cont_sts_uniq_count = Indexer.all.map(&:cont_sts).uniq.count
        loc_status_uniq_count = Indexer.all.map(&:loc_status).uniq.count
        stf_status_uniq_count = Indexer.all.map(&:stf_status).uniq.count
        contact_status_uniq_count = Indexer.all.map(&:contact_status).uniq.count
        raw_url_uniq_count = Indexer.all.map(&:raw_url).uniq.count
        clean_url_uniq_count = Indexer.all.map(&:clean_url).uniq.count
        staff_url_uniq_count = Indexer.all.map(&:staff_url).uniq.count
        staff_text_uniq_count = Indexer.all.map(&:staff_text).uniq.count
        location_url_uniq_count = Indexer.all.map(&:location_url).uniq.count
        location_text_uniq_count = Indexer.all.map(&:location_text).uniq.count
        template_uniq_count = Indexer.all.map(&:template).uniq.count
        contacts_uniq_count = Indexer.all.map(&:contacts_count).uniq.count
        contacts_link_uniq_count = Indexer.all.map(&:contacts_link).uniq.count
        acct_name_uniq_count = Indexer.all.map(&:acct_name).uniq.count
        full_addr_uniq_count = Indexer.all.map(&:full_addr).uniq.count
        street_uniq_count = Indexer.all.map(&:street).uniq.count
        city_uniq_count = Indexer.all.map(&:city).uniq.count
        state_uniq_count = Indexer.all.map(&:state).uniq.count
        zip_uniq_count = Indexer.all.map(&:zip).uniq.count
        phone_uniq_count = Indexer.all.map(&:phone).uniq.count
        acct_pin_uniq_count = Indexer.all.map(&:acct_pin).uniq.count
        raw_street_uniq_count = Indexer.all.map(&:raw_street).uniq.count

        puts "\n\n============ (Indexer (UNIQ) Counts) ============\n"
        puts "indexer_total: #{indexer_total}"
        puts "redirect_status_uniq_count: #{redirect_status_uniq_count}"
        puts "indexer_status_uniq_count: #{indexer_status_uniq_count}"
        puts "loc_status_uniq_count: #{loc_status_uniq_count}"
        puts "stf_status_uniq_count: #{stf_status_uniq_count}"
        puts "contact_status_uniq_count: #{contact_status_uniq_count}"
        puts "who_status_uniq_count: #{who_status_uniq_count}"
        puts "rt_sts_uniq_count: #{rt_sts_uniq_count}"
        puts "cont_sts_uniq_count: #{cont_sts_uniq_count}\n\n"

        puts "raw_url_uniq_count: #{raw_url_uniq_count}"
        puts "clean_url_uniq_count: #{clean_url_uniq_count}"
        puts "staff_url_uniq_count: #{staff_url_uniq_count}"
        puts "staff_text_uniq_count: #{staff_text_uniq_count}"
        puts "location_url_uniq_count: #{location_url_uniq_count}"
        puts "location_text_uniq_count: #{location_text_uniq_count}"
        puts "template_uniq_count: #{template_uniq_count}"
        puts "contacts_uniq_count: #{contacts_uniq_count}"
        puts "contacts_link_uniq_count: #{contacts_link_uniq_count}"
        puts "acct_name_uniq_count: #{acct_name_uniq_count}"
        puts "full_addr_uniq_count: #{full_addr_uniq_count}"
        puts "street_uniq_count: #{street_uniq_count}"
        puts "city_uniq_count: #{city_uniq_count}"
        puts "state_uniq_count: #{state_uniq_count}"
        puts "zip_uniq_count: #{zip_uniq_count}"
        puts "phone_uniq_count: #{phone_uniq_count}"
        puts "acct_pin_uniq_count: #{acct_pin_uniq_count}"
        puts "raw_street_uniq_count: #{raw_street_uniq_count}"

        ##########################################
        ### === TOTALS (not uniq)! === ###
        redirect_status_total = Indexer.all.map(&:redirect_status).count
        indexer_status_total = Indexer.all.map(&:indexer_status).count
        who_status_total = Indexer.all.map(&:who_status).count
        rt_sts_total = Indexer.all.map(&:rt_sts).count
        cont_sts_total = Indexer.all.map(&:cont_sts).count
        loc_status_total = Indexer.all.map(&:loc_status).count
        stf_status_total = Indexer.all.map(&:stf_status).count
        contact_status_total = Indexer.all.map(&:contact_status).count
        raw_url_total = Indexer.all.map(&:raw_url).count
        clean_url_total = Indexer.all.map(&:clean_url).count
        staff_url_total = Indexer.all.map(&:staff_url).count
        staff_text_total = Indexer.all.map(&:staff_text).count
        location_url_total = Indexer.all.map(&:location_url).count
        location_text_total = Indexer.all.map(&:location_text).count
        template_total = Indexer.all.map(&:template).count
        contacts_total = Indexer.all.map(&:contacts_count).count
        contacts_link_total = Indexer.all.map(&:contacts_link).count
        acct_name_total = Indexer.all.map(&:acct_name).count
        full_addr_total = Indexer.all.map(&:full_addr).count
        street_total = Indexer.all.map(&:street).count
        city_total = Indexer.all.map(&:city).count
        state_total = Indexer.all.map(&:state).count
        zip_total = Indexer.all.map(&:zip).count
        phone_total = Indexer.all.map(&:phone).count
        acct_pin_total = Indexer.all.map(&:acct_pin).count
        raw_street_total = Indexer.all.map(&:raw_street).count

        puts "\n\n============ (Indexer [Totals] Counts) ============\n"
        puts "indexer_total: #{indexer_total}"
        puts "redirect_status_total: #{redirect_status_total}"
        puts "indexer_status_total: #{indexer_status_total}"
        puts "loc_status_total: #{loc_status_total}"
        puts "stf_status_total: #{stf_status_total}"
        puts "contact_status_total: #{contact_status_total}"
        puts "who_status_total: #{who_status_total}"
        puts "rt_sts_total: #{rt_sts_total}"
        puts "cont_sts_total: #{cont_sts_total}\n\n"
        puts "raw_url_total: #{raw_url_total}"
        puts "clean_url_total: #{clean_url_total}"
        puts "staff_url_total: #{staff_url_total}"
        puts "staff_text_total: #{staff_text_total}"
        puts "location_url_total: #{location_url_total}"
        puts "location_text_total: #{location_text_total}"
        puts "template_total: #{template_total}"
        puts "contacts_total: #{contacts_total}"
        puts "contacts_link_total: #{contacts_link_total}"
        puts "acct_name_total: #{acct_name_total}"
        puts "full_addr_total: #{full_addr_total}"
        puts "street_total: #{street_total}"
        puts "city_total: #{city_total}"
        puts "state_total: #{state_total}"
        puts "zip_total: #{zip_total}"
        puts "phone_total: #{phone_total}"
        puts "acct_pin_total: #{acct_pin_total}"
        puts "raw_street_total: #{raw_street_total}"
    end


    ## 7. Users ReCalc Method
    def users_dash
        user_total = User.count

        ### === UNIQ COUNTS! === ###
        email_uniq_count = User.all.map(&:email).uniq.count
        last_sign_in_at_uniq_count = User.all.map(&:last_sign_in_at).uniq.count
        current_sign_in_ip_uniq_count = User.all.map(&:current_sign_in_ip).uniq.count
        last_sign_in_ip_uniq_count = User.all.map(&:last_sign_in_ip).uniq.count
        unconfirmed_email_uniq_count = User.all.map(&:unconfirmed_email).uniq.count
        first_name_uniq_count = User.all.map(&:first_name).uniq.count
        last_name_uniq_count = User.all.map(&:last_name).uniq.count
        work_phone_uniq_count = User.all.map(&:work_phone).uniq.count
        mobile_phone_uniq_count = User.all.map(&:mobile_phone).uniq.count
        role_uniq_count = User.all.map(&:role).uniq.count
        department_uniq_count = User.all.map(&:department).uniq.count

        puts "\n\n============ (Users (UNIQ) Counts) ============\n"
        puts "user_total: #{user_total}"
        puts "email_uniq_count: #{email_uniq_count}"
        puts "last_sign_in_at_uniq_count: #{last_sign_in_at_uniq_count}"
        puts "current_sign_in_ip_uniq_count: #{current_sign_in_ip_uniq_count}"
        puts "last_sign_in_ip_uniq_count: #{last_sign_in_ip_uniq_count}"
        puts "unconfirmed_email_uniq_count: #{unconfirmed_email_uniq_count}"
        puts "first_name_uniq_count: #{first_name_uniq_count}"
        puts "last_name_uniq_count: #{last_name_uniq_count}"
        puts "work_phone_uniq_count: #{work_phone_uniq_count}"
        puts "mobile_phone_uniq_count: #{mobile_phone_uniq_count}"
        puts "role_uniq_count: #{role_uniq_count}"
        puts "department_uniq_count: #{department_uniq_count}"

        ##########################################
        ### === TOTALS (not uniq)! === ###
        email_total = User.all.map(&:email).count
        last_sign_in_at_total = User.all.map(&:last_sign_in_at).count
        current_sign_in_ip_total = User.all.map(&:current_sign_in_ip).count
        last_sign_in_ip_total = User.all.map(&:last_sign_in_ip).count
        unconfirmed_email_total = User.all.map(&:unconfirmed_email).count
        first_name_total = User.all.map(&:first_name).count
        last_name_total = User.all.map(&:last_name).count
        work_phone_total = User.all.map(&:work_phone).count
        mobile_phone_total = User.all.map(&:mobile_phone).count
        role_total = User.all.map(&:role).count
        department_total = User.all.map(&:department).count

        puts "\n\n============ (Users [TOTALS] Counts) ============\n"
        puts "user_total: #{user_total}"
        puts "email_total: #{email_total}"
        puts "last_sign_in_at_total: #{last_sign_in_at_total}"
        puts "current_sign_in_ip_total: #{current_sign_in_ip_total}"
        puts "last_sign_in_ip_total: #{last_sign_in_ip_total}"
        puts "unconfirmed_email_total: #{unconfirmed_email_total}"
        puts "first_name_total: #{first_name_total}"
        puts "last_name_total: #{last_name_total}"
        puts "work_phone_total: #{work_phone_total}"
        puts "mobile_phone_total: #{mobile_phone_total}"
        puts "role_total: #{role_total}"
        puts "department_total: #{department_total}"

    end


    ## 8. WhoIs ReCalc Method
    def whos_dash
        who_total = Who.count

        ### === UNIQ COUNTS! === ###
        who_status_uniq_count = Who.all.map(&:who_status).uniq.count
        url_status_uniq_count = Who.all.map(&:url_status).uniq.count
        domain_uniq_count = Who.all.map(&:domain).uniq.count
        domain_id_uniq_count = Who.all.map(&:domain_id).uniq.count
        ip_uniq_count = Who.all.map(&:ip).uniq.count
        server1_uniq_count = Who.all.map(&:server1).uniq.count
        server2_uniq_count = Who.all.map(&:server2).uniq.count
        registrar_url_uniq_count = Who.all.map(&:registrar_url).uniq.count
        registrar_id_uniq_count = Who.all.map(&:registrar_id).uniq.count
        registrant_id_uniq_count = Who.all.map(&:registrant_id).uniq.count
        registrant_type_uniq_count = Who.all.map(&:registrant_type).uniq.count
        registrant_name_uniq_count = Who.all.map(&:registrant_name).uniq.count
        registrant_organization_uniq_count = Who.all.map(&:registrant_organization).uniq.count
        registrant_address_uniq_count = Who.all.map(&:registrant_address).uniq.count
        registrant_city_uniq_count = Who.all.map(&:registrant_city).uniq.count
        registrant_zip_uniq_count = Who.all.map(&:registrant_zip).uniq.count
        registrant_state_uniq_count = Who.all.map(&:registrant_state).uniq.count
        registrant_phone_uniq_count = Who.all.map(&:registrant_phone).uniq.count
        registrant_fax_uniq_count = Who.all.map(&:registrant_fax).uniq.count
        registrant_email_uniq_count = Who.all.map(&:registrant_email).uniq.count
        registrant_url_uniq_count = Who.all.map(&:registrant_url).uniq.count
        admin_id_uniq_count = Who.all.map(&:admin_id).uniq.count
        admin_type_uniq_count = Who.all.map(&:admin_type).uniq.count
        admin_name_uniq_count = Who.all.map(&:admin_name).uniq.count
        admin_organization_uniq_count = Who.all.map(&:admin_organization).uniq.count
        admin_address_uniq_count = Who.all.map(&:admin_address).uniq.count
        admin_city_uniq_count = Who.all.map(&:admin_city).uniq.count
        admin_zip_uniq_count = Who.all.map(&:admin_zip).uniq.count
        admin_state_uniq_count = Who.all.map(&:admin_state).uniq.count
        admin_phone_uniq_count = Who.all.map(&:admin_phone).uniq.count
        admin_fax_uniq_count = Who.all.map(&:admin_fax).uniq.count
        admin_email_uniq_count = Who.all.map(&:admin_email).uniq.count
        admin_url_uniq_count = Who.all.map(&:admin_url).uniq.count
        tech_id_uniq_count = Who.all.map(&:tech_id).uniq.count
        tech_type_uniq_count = Who.all.map(&:tech_type).uniq.count
        tech_name_uniq_count = Who.all.map(&:tech_name).uniq.count
        tech_organization_uniq_count = Who.all.map(&:tech_organization).uniq.count
        tech_address_uniq_count = Who.all.map(&:tech_address).uniq.count
        tech_city_uniq_count = Who.all.map(&:tech_city).uniq.count
        tech_zip_uniq_count = Who.all.map(&:tech_zip).uniq.count
        tech_state_uniq_count = Who.all.map(&:tech_state).uniq.count
        tech_phone_uniq_count = Who.all.map(&:tech_phone).uniq.count
        tech_fax_uniq_count = Who.all.map(&:tech_fax).uniq.count
        tech_email_uniq_count = Who.all.map(&:tech_email).uniq.count
        tech_url_uniq_count = Who.all.map(&:tech_url).uniq.count
        registrant_pin_uniq_count = Who.all.map(&:registrant_pin).uniq.count
        tech_pin_uniq_count = Who.all.map(&:tech_pin).uniq.count
        admin_pin_uniq_count = Who.all.map(&:admin_pin).uniq.count

        puts "\n\n============ (WhoIs (UNIQ) Counts) ============\n"
        puts "who_total: #{who_total}"
        puts "who_status_uniq_count: #{who_status_uniq_count}"
        puts "url_status_uniq_count: #{url_status_uniq_count}"
        puts "domain_uniq_count: #{domain_uniq_count}"
        puts "domain_id_uniq_count: #{domain_id_uniq_count}"
        puts "ip_uniq_count: #{ip_uniq_count}"
        puts "server1_uniq_count: #{server1_uniq_count}"
        puts "server2_uniq_count: #{server2_uniq_count}"
        puts "registrar_url_uniq_count: #{registrar_url_uniq_count}"
        puts "registrar_id_uniq_count: #{registrar_id_uniq_count}"
        puts "registrant_id_uniq_count: #{registrant_id_uniq_count}"
        puts "registrant_type_uniq_count: #{registrant_type_uniq_count}"
        puts "registrant_name_uniq_count: #{registrant_name_uniq_count}"
        puts "registrant_organization_uniq_count: #{registrant_organization_uniq_count}"
        puts "registrant_address_uniq_count: #{registrant_address_uniq_count}"
        puts "registrant_city_uniq_count: #{registrant_city_uniq_count}"
        puts "registrant_zip_uniq_count: #{registrant_zip_uniq_count}"
        puts "registrant_state_uniq_count: #{registrant_state_uniq_count}"
        puts "registrant_phone_uniq_count: #{registrant_phone_uniq_count}"
        puts "registrant_fax_uniq_count: #{registrant_fax_uniq_count}"
        puts "registrant_email_uniq_count: #{registrant_email_uniq_count}"
        puts "registrant_url_uniq_count: #{registrant_url_uniq_count}"
        puts "admin_id_uniq_count: #{admin_id_uniq_count}"
        puts "admin_type_uniq_count: #{admin_type_uniq_count}"
        puts "admin_name_uniq_count: #{admin_name_uniq_count}"
        puts "admin_organization_uniq_count: #{admin_organization_uniq_count}"
        puts "admin_address_uniq_count: #{admin_address_uniq_count}"
        puts "admin_city_uniq_count: #{admin_city_uniq_count}"
        puts "admin_zip_uniq_count: #{admin_zip_uniq_count}"
        puts "admin_state_uniq_count: #{admin_state_uniq_count}"
        puts "admin_phone_uniq_count: #{admin_phone_uniq_count}"
        puts "admin_fax_uniq_count: #{admin_fax_uniq_count}"
        puts "admin_email_uniq_count: #{admin_email_uniq_count}"
        puts "admin_url_uniq_count: #{admin_url_uniq_count}"
        puts "tech_id_uniq_count: #{tech_id_uniq_count}"
        puts "tech_type_uniq_count: #{tech_type_uniq_count}"
        puts "tech_name_uniq_count: #{tech_name_uniq_count}"
        puts "tech_organization_uniq_count: #{tech_organization_uniq_count}"
        puts "tech_address_uniq_count: #{tech_address_uniq_count}"
        puts "tech_city_uniq_count: #{tech_city_uniq_count}"
        puts "tech_zip_uniq_count: #{tech_zip_uniq_count}"
        puts "tech_state_uniq_count: #{tech_state_uniq_count}"
        puts "tech_phone_uniq_count: #{tech_phone_uniq_count}"
        puts "tech_fax_uniq_count: #{tech_fax_uniq_count}"
        puts "tech_email_uniq_count: #{tech_email_uniq_count}"
        puts "tech_url_uniq_count: #{tech_url_uniq_count}"
        puts "registrant_pin_uniq_count: #{registrant_pin_uniq_count}"
        puts "tech_pin_uniq_count: #{tech_pin_uniq_count}"
        puts "admin_pin_uniq_count: #{admin_pin_uniq_count}"

        ##########################################
        ### === TOTALS (not uniq)! === ###
        who_status_total = Who.all.map(&:who_status).count
        url_status_total = Who.all.map(&:url_status).count
        domain_total = Who.all.map(&:domain).count
        domain_id_total = Who.all.map(&:domain_id).count
        ip_total = Who.all.map(&:ip).count
        server1_total = Who.all.map(&:server1).count
        server2_total = Who.all.map(&:server2).count
        registrar_url_total = Who.all.map(&:registrar_url).count
        registrar_id_total = Who.all.map(&:registrar_id).count
        registrant_id_total = Who.all.map(&:registrant_id).count
        registrant_type_total = Who.all.map(&:registrant_type).count
        registrant_name_total = Who.all.map(&:registrant_name).count
        registrant_organization_total = Who.all.map(&:registrant_organization).count
        registrant_address_total = Who.all.map(&:registrant_address).count
        registrant_city_total = Who.all.map(&:registrant_city).count
        registrant_zip_total = Who.all.map(&:registrant_zip).count
        registrant_state_total = Who.all.map(&:registrant_state).count
        registrant_phone_total = Who.all.map(&:registrant_phone).count
        registrant_fax_total = Who.all.map(&:registrant_fax).count
        registrant_email_total = Who.all.map(&:registrant_email).count
        registrant_url_total = Who.all.map(&:registrant_url).count
        admin_id_total = Who.all.map(&:admin_id).count
        admin_type_total = Who.all.map(&:admin_type).count
        admin_name_total = Who.all.map(&:admin_name).count
        admin_organization_total = Who.all.map(&:admin_organization).count
        admin_address_total = Who.all.map(&:admin_address).count
        admin_city_total = Who.all.map(&:admin_city).count
        admin_zip_total = Who.all.map(&:admin_zip).count
        admin_state_total = Who.all.map(&:admin_state).count
        admin_phone_total = Who.all.map(&:admin_phone).count
        admin_fax_total = Who.all.map(&:admin_fax).count
        admin_email_total = Who.all.map(&:admin_email).count
        admin_url_total = Who.all.map(&:admin_url).count
        tech_id_total = Who.all.map(&:tech_id).count
        tech_type_total = Who.all.map(&:tech_type).count
        tech_name_total = Who.all.map(&:tech_name).count
        tech_organization_total = Who.all.map(&:tech_organization).count
        tech_address_total = Who.all.map(&:tech_address).count
        tech_city_total = Who.all.map(&:tech_city).count
        tech_zip_total = Who.all.map(&:tech_zip).count
        tech_state_total = Who.all.map(&:tech_state).count
        tech_phone_total = Who.all.map(&:tech_phone).count
        tech_fax_total = Who.all.map(&:tech_fax).count
        tech_email_total = Who.all.map(&:tech_email).count
        tech_url_total = Who.all.map(&:tech_url).count
        registrant_pin_total = Who.all.map(&:registrant_pin).count
        tech_pin_total = Who.all.map(&:tech_pin).count
        admin_pin_total = Who.all.map(&:admin_pin).count

        puts "\n\n============ (WhoIs [TOTALS] Counts) ============\n"
        puts "who_total: #{who_total}"
        puts "who_status_total: #{who_status_total}"
        puts "url_status_total: #{url_status_total}"
        puts "domain_total: #{domain_total}"
        puts "domain_id_total: #{domain_id_total}"
        puts "ip_total: #{ip_total}"
        puts "server1_total: #{server1_total}"
        puts "server2_total: #{server2_total}"
        puts "registrar_url_total: #{registrar_url_total}"
        puts "registrar_id_total: #{registrar_id_total}"
        puts "registrant_id_total: #{registrant_id_total}"
        puts "registrant_type_total: #{registrant_type_total}"
        puts "registrant_name_total: #{registrant_name_total}"
        puts "registrant_organization_total: #{registrant_organization_total}"
        puts "registrant_address_total: #{registrant_address_total}"
        puts "registrant_city_total: #{registrant_city_total}"
        puts "registrant_zip_total: #{registrant_zip_total}"
        puts "registrant_state_total: #{registrant_state_total}"
        puts "registrant_phone_total: #{registrant_phone_total}"
        puts "registrant_fax_total: #{registrant_fax_total}"
        puts "registrant_email_total: #{registrant_email_total}"
        puts "registrant_url_total: #{registrant_url_total}"
        puts "admin_id_total: #{admin_id_total}"
        puts "admin_type_total: #{admin_type_total}"
        puts "admin_name_total: #{admin_name_total}"
        puts "admin_organization_total: #{admin_organization_total}"
        puts "admin_address_total: #{admin_address_total}"
        puts "admin_city_total: #{admin_city_total}"
        puts "admin_zip_total: #{admin_zip_total}"
        puts "admin_state_total: #{admin_state_total}"
        puts "admin_phone_total: #{admin_phone_total}"
        puts "admin_fax_total: #{admin_fax_total}"
        puts "admin_email_total: #{admin_email_total}"
        puts "admin_url_total: #{admin_url_total}"
        puts "tech_id_total: #{tech_id_total}"
        puts "tech_type_total: #{tech_type_total}"
        puts "tech_name_total: #{tech_name_total}"
        puts "tech_organization_total: #{tech_organization_total}"
        puts "tech_address_total: #{tech_address_total}"
        puts "tech_city_total: #{tech_city_total}"
        puts "tech_zip_total: #{tech_zip_total}"
        puts "tech_state_total: #{tech_state_total}"
        puts "tech_phone_total: #{tech_phone_total}"
        puts "tech_fax_total: #{tech_fax_total}"
        puts "tech_email_total: #{tech_email_total}"
        puts "tech_url_total: #{tech_url_total}"
        puts "registrant_pin_total: #{registrant_pin_total}"
        puts "tech_pin_total: #{tech_pin_total}"
        puts "admin_pin_total: #{admin_pin_total}"

    end


    def dash(model)
        cols = model.column_names
        cols.delete("id")
        cols.delete("created_at")
        cols.delete("updated_at")

        puts "#{'='*30} Total count #{'='*30}"
        cols.each do |col|
            num = model.all.map(&col.to_sym).count
            puts "#{col}: #{num}"
        end
        puts "#{'='*30} Unique count #{'='*30}"
        cols.each do |col|
            num = model.all.map(&col.to_sym).uniq.count
            puts "#{col}: #{num}"
        end
    end

    def item_list(model, attrs) # item_list(Staffer, [:staffer_status, :cont_status])
        list_hash = {}
        puts "#{'='*30} Item List #{'='*30}"
        attrs.each do |att|
            list_hash[att] = model.all.map(&att).uniq
            puts "#{att}: #{list_hash[att]}"
        end
        list_hash
    end

end # DashboardService class Ends ---
