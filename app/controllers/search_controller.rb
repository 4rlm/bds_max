class SearchController < ApplicationController
    def index

        # ====== Google API Starts =========
        if params[:q]
          page = params[:page] || 1
          @results = GoogleCustomSearchApi.search(params[:q], page: page)
        end
        # ====== Google API Ends =========
        



        #========================
        # Core Instance Variables
        #========================

        # Core All
        @core_all = Core.count
        #============

        # Core BDS Status: Imported
        @core_bds_status_imported = Core.where(bds_status: "Imported").count
        # Core BDS Status: Queue
        @core_bds_status_queue = Core.where(bds_status: "Queue").count
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
        @core_sp_huffmeyer = Core.where(sfdc_sales_person: "Justin Huffmeyer").count
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
        set_selected_status_core({bds_status: params[:bds_status], url_comparison: params[:url_comparison], root_comparison: params[:root_comparison], sfdc_type: params[:sfdc_type], sfdc_sales_person: params[:sfdc_sales_person], sfdc_tier: params[:sfdc_tier], sfdc_ult_grp: params[:sfdc_ult_grp], sfdc_group: params[:sfdc_group], sfdc_city: params[:sfdc_city], sfdc_state: params[:sfdc_state], sfdc_zip: params[:sfdc_zip]})
        redirect_to cores_path
    end

    def search_result_gcse
        set_selected_status_gcse({domain_status: params[:domain_status], gcse_result_num: params[:gcse_result_num], gcse_timestamp: params[:gcse_timestamp], sfdc_ult_acct: params[:sfdc_ult_acct], sfdc_acct: params[:sfdc_acct], sfdc_type: params[:sfdc_type], sfdc_city: params[:sfdc_city], sfdc_state: params[:sfdc_state]})
        redirect_to gcses_path
    end


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
