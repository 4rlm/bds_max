class SearchController < ApplicationController
    def index

        # == Google API Starts ==Test ! Starts ===
        if params[:q]
          page = params[:page]
          @results = GoogleCustomSearchApi.search(params[:q], page: page)
        end

        # @results = GoogleCustomSearchApi.search(@test_encoded_search)
        # @results = GoogleCustomSearchApi.search("poker", page: 2)
        # @results.pages == 10
        # @results.current_page == 2
        # @results.next_page == 3
        # @results.previous_page == 1
        # @results = GoogleCustomSearchApi.search_and_return_all_results('grossinger toyota')
        # @results = search_and_return_all_results('grossinger toyota')
        # @results.first.items.size # == 10
        # == Google API Starts ==Test ! Ends ===

        # == Google API Starts ==Perfect! Starts ===
        # if params[:q]
        #   page = params[:page] || 1
        #   @results = GoogleCustomSearchApi.search(params[:q], page: page)
        # end
        # == Google API Starts ==Perfect! Ends ===

        #========================
        # Core (Accounts) Instance Variables
        #========================

        # Core All
        @core_all = Core.count
        #============

        # Core BDS Status
        @core_bds_status_imported = Core.where(bds_status: "Imported").count
        @core_bds_status_queue_domainer = Core.where(bds_status: "Queue Domainer").count
        @core_bds_status_dom_result = Core.where(bds_status: "Dom Result").count
        @core_bds_status_matched = Core.where(bds_status: "Matched").count
        @core_bds_status_no_matches = Core.where(bds_status: "No Matches").count
        @core_bds_status_queue_indexer = Core.where(bds_status: "Queue Indexer").count
        @core_bds_status_indexer_result = Core.where(bds_status: "Indexer Result").count


        #============

        # Core URL Comparison
        @urls_updated = Core.where(url_comparison: "Different").count
        @roots_updated = Core.where(root_comparison: "Different").count
        #============

        # Core Salesperson
        @core_sp_peckler = Core.where(sfdc_sales_person: "Marc Peckler").count
        @core_sp_rosen = Core.where(sfdc_sales_person: "Ben Rosen").count
        @core_sp_price = Core.where(sfdc_sales_person: "Jason Price").count
        @core_sp_thompson = Core.where(sfdc_sales_person: "Sarah Thompson").count
        @core_sp_huffmeyer = Core.where(sfdc_sales_person: "Justin Hufmeyer").count
        #============

        # Core Type
        @core_type_canceled = Core.where(sfdc_type: "Canceled").count
        @core_type_current_account = Core.where(sfdc_type: "Current Account").count
        @core_type_current_sub_account = Core.where(sfdc_type: "Current Sub-account").count
        @core_type_distribution_partner = Core.where(sfdc_type: "Distribution Partner").count
        @core_type_do_not_solicit = Core.where(sfdc_type: "Do Not Solicit").count
        @core_type_failure_to_launch = Core.where(sfdc_type: "Failure To Launch").count
        @core_type_group_division = Core.where(sfdc_type: "Group Division").count
        @core_type_group_name = Core.where(sfdc_type: "Group Name").count
        @core_type_inactive = Core.where(sfdc_type: "Inactive").count
        @core_type_influencer = Core.where(sfdc_type: "Influencer").count
        @core_type_max_digital_demo_store = Core.where(sfdc_type: "Max Digital Demo Store").count
        @core_type_prospect = Core.where(sfdc_type: "Prospect").count
        @core_type_prospect_sub_account = Core.where(sfdc_type: "Prospect Sub-account").count
        @core_type_vendor = Core.where(sfdc_type: "Vendor").count
        #============

        # Core Sales Tier
        @core_tier_1 = Core.where(sfdc_tier: "Tier 1").count
        @core_tier_2 = Core.where(sfdc_tier: "Tier 2").count
        @core_tier_3 = Core.where(sfdc_tier: "Tier 3").count
        @core_tier_4 = Core.where(sfdc_tier: "Tier 4").count
        @core_tier_5 = Core.where(sfdc_tier: "Tier 5").count
        #============

        # URL Comparison
        @core_url_comparison_same = Core.where(url_comparison: "Same").count
        @core_url_comparison_different = Core.where(url_comparison: "Different").count
        @core_root_comparison_same = Core.where(root_comparison: "Same").count
        @core_root_comparison_different = Core.where(root_comparison: "Different").count
        #============

        # Analysis
        # franchise dealers

        #========================
        # Gcse (Domainer) Instance Variables
        #========================

        # Gcse All
        @gcse_all = Gcse.count

        # Domainer Queries
        @gcse_query_count = get_domainer_query_count
        @gcse_domain_status_dom_result = Gcse.where(domain_status: "Dom Result").count
        @gcse_domain_status_no_auto_matches = Gcse.where(domain_status: "No Auto-Matches").count

        #========================
        # Discoveries Instance Variables
        #========================
        # Solitary All
         @solitary_all = Solitary.count

        #  Pending Verification All
        @pending_verification_all = PendingVerification.count

         #========================
         # IndexerStaffs Instance Variables
         #========================
         @indexer_staff_all = IndexerStaff.count
         @indexer_staff_status_matched = IndexerStaff.where(indexer_status: "Matched").count
         @indexer_staff_status_no_matches = IndexerStaff.where(indexer_status: "No Matches").count
         @indexer_staff_status_error = IndexerStaff.where(indexer_status: "Error").count
         @indexer_staff_status_try_again = IndexerStaff.where(indexer_status: "Try Again").count
         @indexer_staff_status_verified = IndexerStaff.where(indexer_status: "Verified").count
         @indexer_staff_status_ready = IndexerStaff.where(indexer_status: "Ready").count

         #========================
         # IndexerLocations Instance Variables
         #========================
         @indexer_location_all = IndexerLocation.count

         @indexer_location_status_matched = IndexerLocation.where(indexer_status: "Matched").count
         @indexer_location_status_no_matches = IndexerLocation.where(indexer_status: "No Matches").count
         @indexer_location_status_error = IndexerLocation.where(indexer_status: "Error").count
         @indexer_location_status_try_again = IndexerLocation.where(indexer_status: "Try Again").count
         @indexer_location_status_verified = IndexerLocation.where(indexer_status: "Verified").count
         @indexer_location_status_ready = IndexerLocation.where(indexer_status: "Ready").count

         #========================
         # Staffers (Contacts) Instance Variables
         #========================
         @staffer_all = Staffer.count

        #  staffer_status


    end

    def search_result_core
        # {bds_status: params[:bds_status], sfdc_type: params[:sfdc_type], col_name: params[:col_name]}
        set_selected_status_core({bds_status: params[:bds_status], url_comparison: params[:url_comparison], root_comparison: params[:root_comparison], sfdc_type: params[:sfdc_type], sfdc_sales_person: params[:sfdc_sales_person], sfdc_tier: params[:sfdc_tier], sfdc_ult_grp: params[:sfdc_ult_grp], sfdc_group: params[:sfdc_group], sfdc_city: params[:sfdc_city], sfdc_state: params[:sfdc_state], sfdc_zip: params[:sfdc_zip], sfdc_acct: params[:sfdc_acct], sfdc_id: params[:sfdc_id], sfdc_ph: params[:sfdc_ph], staff_indexer_status: params[:staff_indexer_status], location_indexer_status: params[:location_indexer_status] })
        redirect_to cores_path
    end

    def search_result_gcse
        set_selected_status_gcse({domain_status: params[:domain_status], gcse_result_num: params[:gcse_result_num], gcse_timestamp: params[:gcse_timestamp], sfdc_ult_acct: params[:sfdc_ult_acct], sfdc_acct: params[:sfdc_acct], sfdc_type: params[:sfdc_type], sfdc_city: params[:sfdc_city], sfdc_state: params[:sfdc_state], sfdc_id: params[:sfdc_id], sfdc_url_o: params[:sfdc_url_o], domain: params[:domain], root: params[:root], sfdc_root: params[:sfdc_root]})
        redirect_to gcses_path
    end


    # == Google API Testing Search Methods - Starts ===

    # == Testing MY Google API - Search Method V1 - Perfect! ==
    # def test_encoded_search
    #     q = "automobile dealerships in hawaii"
    # end
    # == Testing MY Google API - Search Method V1 - Ends  ==


    # == Testing MY Google API - Search Method V2 ==
    def test_encoded_search
        # q = "automobile dealerships in hawaii"

        #-----------------
        acct = "Larry H. Miller Hyundai Peoria"
        street = "8425 W Bell Rd"
        city = "Peoria"
        state = "AZ"

        #-----------------
        # if acct != nil
            acct_gs = acct.gsub(/[ ]/, '%20')
            acct_q = "#{acct_gs}+"
        # end
        # if street != nil
            street_gs = street.gsub(/[ ]/, '%20')
            street_q = "#{street_gs}+"
        # end
        # if city != nil
            city_gs = city.gsub(/[ ]/, '%20')
            city_q = "#{city_gs}+"
        # end
        # if state != nil
            state_st = state
        # end

        #-----------------
        # q = "#{acct}#{city},#{state}"


        # num = "&num=100"
        # client = "&client=google-csbe"
        # key = "&cx=016494735141549134606:xzyw78w1vn0"
        # tag1 = "&as_oq=auto+automobile+car+cars+vehicle+vehicles"
        # tag2 = "&as_oq=dealer+dealership+group"

        # q_combinded = "q=#{acct_q}#{street_q}#{city_q}#{state_st}"
        # acct_req = "&as_epq=#{acct_gs}"
        # acct_opt = "&oq=#{acct_gs}"

        # q = "#{acct_q}#{street_q}#{city_q}#{state_st}"
        # q = "#{acct}#{street}#{city}#{state}#{num}"
        # q = "automobile dealerships in hawaii"

    end
    # == Testing MY Google API - Search Method V2 - Ends  ==



    # == Google API Testing Search Methods - Ends ===


    private

    def get_domainer_query_count
        counter = 0
        Core.all.each do |core|
            if core.domainer_date
                counter += 1
            end
        end
        counter
    end
end
