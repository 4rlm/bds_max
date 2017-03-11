class CoresController < ApplicationController
    before_action :intermediate_and_up, only: [:index, :show, :search, :quick_core_view_queue]
    before_action :advanced_and_up, only: [:edit, :update]
    before_action :admin_only, only: [:new, :create, :destroy, :import_page, :import_core_data, :core_comp_cleaner_btn, :anything_btn, :col_splitter_btn]
    before_action :set_core, only: [:show, :edit, :update, :destroy]
    before_action :set_core_service, only: [:index, :core_comp_cleaner_btn, :anything_btn, :col_splitter_btn]

    # GET /cores
    # GET /cores.json
    def index
        if choice_hash = get_selected_status_core
            clean_choice_hash = {}
            @view_mode = choice_hash[:view_mode]

            choice_hash.each do |key, value|
                clean_choice_hash[key] = value if !value.nil? && value != "" && key != :view_mode
            end
            @selected_data = Core.where(clean_choice_hash)
        else # choice_hash is nil
            @selected_data = Core.all
        end

        # @cores = @selected_data.filter(filtering_params(params)).limit(20)

        # @cores_limited = @selected_data.limit(20)

        @selected_data = @selected_data.order(updated_at: :desc)

        @cores = @selected_data.filter(filtering_params(params)).paginate(:page => params[:page], :per_page => 10)


        @cores_count = Core.count
        @selected_core_count = @selected_data.count


        cores_csv = @selected_data.order(:sfdc_id)
        respond_to do |format|
            format.html
            format.csv { render text: cores_csv.to_csv }
        end

        # Checkbox
        batch_status
    end

    # GET /cores/1
    # GET /cores/1.json
    def show
    end

    # GET /cores/new
    def new
        @core = Core.new
    end

    # Go to the CSV importing page
    def import_page
    end

    def import_core_data
        file_name = params[:file]
        Core.import_csv(file_name)

        flash[:notice] = "CSV imported successfully."
        redirect_to cores_path
    end

    # GET /cores/1/edit
    def edit
    end

    def search
        @cores_count = Core.count
    end

    # POST /cores
    # POST /cores.json
    def create
        @core = Core.new(core_params)

        respond_to do |format|
            if @core.save
                format.html { redirect_to @core, notice: 'Core was successfully created.' }
                format.json { render :show, status: :created, location: @core }
            else
                format.html { render :new }
                format.json { render json: @core.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /cores/1
    # PATCH/PUT /cores/1.json
    def update
        respond_to do |format|
            if @core.update(core_params)
                format.html { redirect_to @core, notice: 'Core was successfully updated.' }
                format.json { render :show, status: :ok, location: @core }
            else
                format.html { render :edit }
                format.json { render json: @core.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /cores/1
    # DELETE /cores/1.json
    def destroy
        @core.destroy
        respond_to do |format|
            format.html { redirect_to cores_url, notice: 'Core was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    def core_comp_cleaner_btn
        @core_service.core_comp_cleaner_btn
        flash[:notice] = "Core(Comparison) cleaned successfully."
        redirect_to cores_path
    end

    def quick_core_view_queue
        set_selected_status_core({"bds_status"=>["Queue Domainer"]})

        redirect_to cores_path
    end

    def anything_btn
        # previously called franchiser_btn
        # !! CAUTION !!
        # @core_service.core_data_dumper
        # @core_service.delay.core_full_address_cleaner
        # @core_service.core_full_address_cleaner
        # @core_service.core_acct_name_cleaner

        # @core_service.phone_formatter

        # @core_service.geo_missing_street_num

        # @core_service.image_mover

        # @core_service.hybrid_address_matcher

        # @core_service.account_matcher

        # @core_service.core_staffer_domain_cleaner
        @core_service.delay.core_staffer_domain_cleaner



        # @core_service.period_remover


        ### Above are Dangerous!  Use w/ Care!  ###
        #############################

        # @core_service.core_root_formatter

        # @core_service.delay.franchise_resetter
        # @core_service.franchise_resetter
        # @core_service.delay.franchise_termer
        # @core_service.franchise_termer
        # @core_service.delay.franchise_consolidator
        # @core_service.franchise_consolidator

        # redirect_to root_path
        redirect_to search_path

    end

    def col_splitter_btn
        @core_service.col_splitter
        redirect_to root_path
    end


    private
    # Use callbacks to share common setup or constraints between actions.
    def set_core
        @core = Core.find(params[:id])
    end

    def set_core_service
        @core_service = CoreService.new
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def core_params
        params.require(:core).permit(:bds_status, :sfdc_id, :sfdc_tier, :sfdc_sales_person, :sfdc_type, :sfdc_ult_grp, :sfdc_ult_rt, :sfdc_group, :sfdc_grp_rt, :sfdc_acct, :sfdc_street, :sfdc_city, :sfdc_state, :sfdc_zip, :sfdc_ph, :sfdc_url, :created_at, :updated_at, :core_date, :domainer_date, :indexer_date, :staffer_date, :staff_indexer_status, :location_indexer_status, :inventory_indexer_status, :staff_link, :staff_text, :location_link, :location_text, :domain_status, :staffer_status, :sfdc_franchise, :sfdc_franch_cat, :acct_source, :full_address, :latitude, :longitude, :geo_status, :geo_date, :coordinates, :sfdc_franch_cons, :sfdc_template, :geo_address, :geo_acct, :sfdc_clean_url, :crm_acct_pin, :web_acct_pin, :crm_phones, :web_phones)
    end

    def filtering_params(params)
        params.slice(:bds_status, :sfdc_id, :sfdc_tier, :sfdc_sales_person, :sfdc_type, :sfdc_ult_grp, :sfdc_ult_rt, :sfdc_group, :sfdc_grp_rt, :sfdc_acct, :sfdc_street, :sfdc_city, :sfdc_state, :sfdc_zip, :sfdc_ph, :sfdc_url, :created_at, :updated_at, :core_date, :domainer_date, :indexer_date, :staffer_date, :staff_indexer_status, :location_indexer_status, :inventory_indexer_status, :staff_link, :staff_text, :location_link, :location_text, :domain_status, :staffer_status, :sfdc_franchise, :sfdc_franch_cat, :acct_source, :full_address, :latitude, :longitude, :geo_status, :geo_date, :coordinates, :sfdc_franch_cons, :sfdc_template, :geo_address, :geo_acct, :sfdc_clean_url, :crm_acct_pin, :web_acct_pin, :crm_phones, :web_phones)
    end

    def batch_status
        ids = params[:status_checks]
        status = params[:selected_status]
        unless ids.nil?
            for id in ids
                data = Core.find(id)
                data.update_attribute(:bds_status, status)
            end
            # Queue
            if status == 'Queue Domainer'
                start_domainer(ids)
            elsif status == 'Queue Indexer'
                start_indexer(ids)
            elsif status == 'Queue Staffer'
                start_staffer(ids)
            elsif status == 'Queue Geo'
                geo_starter(ids)
            end
        end
    end

    def start_domainer(ids)
        @core_service.delay.scrape_listing(ids)
        # @core_service.scrape_listing(ids)
        flash[:notice] = 'Domainer started!'
        # redirect_to gcses_path
        redirect_to cores_path
    end

    def start_indexer(ids)
        IndexerService.new.delay.start_indexer(ids)
        # IndexerService.new.start_indexer(ids)
        flash[:notice] = 'Indexer started!'
        redirect_to cores_path
    end

    def start_staffer(ids)
        StafferService.new.delay.start_staffer(ids)
        # StafferService.new.start_staffer(ids)

        flash[:notice] = 'Staffer started!'
        # redirect_to staffers_path
        redirect_to cores_path
    end

    def geo_starter(ids)  ## From 'Queue Geo' Batch Select

        LocationService.new.delay.geo_starter(ids)

        flash[:notice] = 'Geo started!'
        redirect_to cores_path
    end
end
