class SearchController < ApplicationController
    def index
        # Core Instance Variables
        @core_all = Core.count
        @domainer_query_count = get_domainer_query_count
        @core_matched_count = Core.where(bds_status: "Matched").count
        @core_no_matches_count = Core.where(bds_status: "No Matches").count
        @core_dom_result_count = Core.where(bds_status: "Dom Result").count

        @urls_updated = Core.where(url_comparison: "Different").count
        @roots_updated = Core.where(root_comparison: "Different").count

        # Gcse Instance Variables
        @gcse_all = Gcse.count

        # Solitaries Instance Variables
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
