class SearchController < ApplicationController
    def index
    end

    def search_result
        set_selected_status(params[:domain_status])
        redirect_to gcses_path
    end
end
