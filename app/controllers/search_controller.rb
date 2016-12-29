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
        # Core Instance Variables
        #========================

        # Core All
        @core_all = Core.count
        #============

        # Core BDS Status: Imported
        @core_bds_status_imported = Core.where(bds_status: "Imported").count
        # Core BDS Status: Queue Domainer
        @core_bds_status_queue = Core.where(bds_status: "Queue Domainer").count
        # Core BDS Status: Dom Result
        @core_bds_status_dom_result = Core.where(bds_status: "Dom Result").count
        # Core BDS Status: Matched
        @core_bds_status_matched = Core.where(bds_status: "Matched").count
        # Core BDS Status: No Matches
        @core_bds_status_no_matches = Core.where(bds_status: "No Matches").count
        #============

        # Core URL Comparison: Different
        @urls_updated = Core.where(url_comparison: "Different").count
        # Core Root Comparison: Different
        @roots_updated = Core.where(root_comparison: "Different").count
        #============

        # Core Salesperson: Marc Peckler
        @core_sp_peckler = Core.where(sfdc_sales_person: "Marc Peckler").count
        # Core Salesperson: Ben Rosen
        @core_sp_rosen = Core.where(sfdc_sales_person: "Ben Rosen").count
        # Core Salesperson: Jason Price
        @core_sp_price = Core.where(sfdc_sales_person: "Jason Price").count
        # Core Salesperson: Sarah Thompson
        @core_sp_thompson = Core.where(sfdc_sales_person: "Sarah Thompson").count
        # Core Salesperson: Justin Huffmeyer
        @core_sp_huffmeyer = Core.where(sfdc_sales_person: "Justin Hufmeyer").count
        #============

        # Core Type: Canceled
        @core_type_canceled = Core.where(sfdc_type: "Canceled").count
        # Core Type: Current Account
        @core_type_current_account = Core.where(sfdc_type: "Current Account").count
        # Core Type: Current Sub-account
        @core_type_current_sub_account = Core.where(sfdc_type: "Current Sub-account").count
        # Core Type: Distribution Partner
        @core_type_distribution_partner = Core.where(sfdc_type: "Distribution Partner").count
        # Core Type: Do Not Solicit
        @core_type_do_not_solicit = Core.where(sfdc_type: "Do Not Solicit").count
        # Core Type: Failure To Launch
        @core_type_failure_to_launch = Core.where(sfdc_type: "Failure To Launch").count
        # Core Type: Group Division
        @core_type_group_division = Core.where(sfdc_type: "Group Division").count
        # Core Type: Group Name
        @core_type_group_name = Core.where(sfdc_type: "Group Name").count
        # Core Type: Inactive
        @core_type_inactive = Core.where(sfdc_type: "Inactive").count
        # Core Type: Influencer
        @core_type_influencer = Core.where(sfdc_type: "Influencer").count
        # Core Type: Max Digital Demo Store
        @core_type_max_digital_demo_store = Core.where(sfdc_type: "Max Digital Demo Store").count
        # Core Type: Prospect
        @core_type_prospect = Core.where(sfdc_type: "Prospect").count
        # Core Type: Prospect Sub-account
        @core_type_prospect_sub_account = Core.where(sfdc_type: "Prospect Sub-account").count
        # Core Type: Vendor
        @core_type_vendor = Core.where(sfdc_type: "Vendor").count
        #============

        # Core Sales Tier: Sales Tier 1
        @core_tier_1 = Core.where(sfdc_tier: "Tier 1").count
        # Core Sales Tier: Sales Tier 2
        @core_tier_2 = Core.where(sfdc_tier: "Tier 2").count
        # Core Sales Tier: Sales Tier 3
        @core_tier_3 = Core.where(sfdc_tier: "Tier 3").count
        # Core Sales Tier: Sales Tier 4
        @core_tier_4 = Core.where(sfdc_tier: "Tier 4").count
        # Core Sales Tier: Sales Tier 5
        @core_tier_5 = Core.where(sfdc_tier: "Tier 5").count
        #============

        # URL Comparison: Same
        @core_url_comparison_same = Core.where(url_comparison: "Same").count
        # URL Comparison: Different
        @core_url_comparison_different = Core.where(url_comparison: "Different").count
        # Root Comparison: Same
        @core_root_comparison_same = Core.where(root_comparison: "Same").count
        # Root Comparison: Different
        @core_root_comparison_different = Core.where(root_comparison: "Different").count
        #============

        #========================
        # Domainer (Gcse) Instance Variables
        #========================

        # Gcse All
        # Domainer All
        @gcse_all = Gcse.count

        # Domainer Queries
        @gcse_query_count = get_domainer_query_count
        # Domain Status: Dom Result
        @gcse_domain_status_dom_result = Gcse.where(domain_status: "Dom Result").count
        # Domain Status: No Auto-Matches
        @gcse_domain_status_no_auto_matches = Gcse.where(domain_status: "No Auto-Matches").count

        # Solitary All
         @solitary_all = Solitary.count
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
