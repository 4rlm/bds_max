class SearchController < ApplicationController
    def index
    end

    def search_result_core
        set_selected_status_core(params[:bds_status])
        redirect_to cores_path
    end

    def search_result
        set_selected_status(params[:domain_status])
        redirect_to gcses_path
    end
end