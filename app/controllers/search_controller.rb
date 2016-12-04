class SearchController < ApplicationController
    def index
        # Core Instance Variables
        @core_all = Core.count
        @domainer_query_count = get_domainer_query_count
        @core_matched_count = Core.where(bds_status: "Matched").count
        @core_dom_result_count = Core.where(bds_status: "Dom Result").count

        # Gcse Instance Variables
        @gcse_all = Gcse.count
    end

    def search_result_core
        # {bds_status: params[:bds_status], sfdc_type: params[:sfdc_type], col_name: params[:col_name]}
        set_selected_status_core({bds_status: params[:bds_status], sfdc_type: params[:sfdc_type]})
        redirect_to cores_path
    end

    def search_result_gcse
        set_selected_status_gcse({domain_status: params[:domain_status]})
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
