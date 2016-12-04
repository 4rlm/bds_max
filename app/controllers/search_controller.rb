class SearchController < ApplicationController
    def index
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
end
