class DashboardService

    def dash_starter
        cores_dash
    end

    def cores_dash
        # Core.all.map(&:HERE).uniq
        # Core.all.map(&:HERE).uniq.count

        ### === CORE STATUS COUNTS === ###
        # acct_merge_stat_count = Core.all.map(&:acct_merge_stat).uniq.count
        # acct_merge_stat_dt_count = Core.all.map(&:acct_merge_stat_dt).uniq.count
        # cont_merge_stat_count = Core.all.map(&:cont_merge_stat).uniq.count
        # cont_merge_stat_dt_count = Core.all.map(&:cont_merge_stat_dt).uniq.count

        bds_status_count = Core.all.map(&:bds_status).uniq.count
        staff_indexer_status_count = Core.all.map(&:staff_indexer_status).uniq.count
        location_indexer_status_count = Core.all.map(&:location_indexer_status).uniq.count
        domain_status_count = Core.all.map(&:domain_status).uniq.count
        staffer_status_count = Core.all.map(&:staffer_status).uniq.count
        geo_status_count = Core.all.map(&:geo_status).uniq.count
        who_status_count = Core.all.map(&:who_status).uniq.count

        puts "\n\n============ (CORE STATUS COUNTS) ============\n"
        puts "bds_status_count: #{bds_status_count}"
        puts "staff_indexer_status_count: #{staff_indexer_status_count}"
        puts "location_indexer_status_count: #{location_indexer_status_count}"
        puts "domain_status_count: #{domain_status_count}"
        puts "staffer_status_count: #{staffer_status_count}"
        puts "geo_status_count: #{geo_status_count}"
        puts "who_status_count: #{who_status_count}"



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


end # DashboardService class Ends ---
