class CoresController < ApplicationController
    before_action :intermediate_and_up, only: [:index, :show, :search]
    before_action :advanced_and_up, only: [:edit, :update, :merge_data, :flag_data, :drop_data]
    before_action :admin_only, only: [:new, :create, :destroy, :import_page, :import_core_data, :core_comp_cleaner_btn, :anything_btn, :col_splitter_btn]
    before_action :set_core, only: [:show, :edit, :update, :destroy]
    before_action :set_core_service, only: [:index, :core_comp_cleaner_btn, :anything_btn, :col_splitter_btn, :merge_data, :flag_data, :drop_data]

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

        # Get dropdown option list from Dashboard
        @acct_source_opts = Dashboard.find_by(db_name: "Core", col_name: "acct_source").item_list
        @bds_status_opts = Dashboard.find_by(db_name: "Core", col_name: "bds_status").item_list
        @conf_cat_opts = Dashboard.find_by(db_name: "Core", col_name: "conf_cat").item_list
        @geo_status_opts = Dashboard.find_by(db_name: "Core", col_name: "geo_status").item_list
        @location_indexer_status_opts = Dashboard.find_by(db_name: "Core", col_name: "location_indexer_status").item_list
        @org_match_status_opts = Dashboard.find_by(db_name: "Core", col_name: "org_match_status").item_list
        @ph_match_status_opts = Dashboard.find_by(db_name: "Core", col_name: "ph_match_status").item_list
        @pin_match_status_opts = Dashboard.find_by(db_name: "Core", col_name: "pin_match_status").item_list
        @sfdc_franch_cat_opts = Dashboard.find_by(db_name: "Core", col_name: "sfdc_franch_cat").item_list
        @sfdc_state_opts = Dashboard.find_by(db_name: "Core", col_name: "sfdc_state").item_list
        @sfdc_tier_opts = Dashboard.find_by(db_name: "Core", col_name: "sfdc_tier").item_list
        @sfdc_type_opts = Dashboard.find_by(db_name: "Core", col_name: "sfdc_type").item_list
        @staff_indexer_status_opts = Dashboard.find_by(db_name: "Core", col_name: "staff_indexer_status").item_list
        @staffer_status_opts = Dashboard.find_by(db_name: "Core", col_name: "staffer_status").item_list
        @url_match_status_opts = Dashboard.find_by(db_name: "Core", col_name: "url_match_status").item_list
        @who_status_opts = Dashboard.find_by(db_name: "Core", col_name: "who_status").item_list


        cores_csv = @selected_data.order(:sfdc_id)
        respond_to do |format|
            format.html
            format.csv { render text: cores_csv.to_csv }
        end

        # Checkbox - Deprecated!
        # batch_status
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
        @service.core_comp_cleaner_btn
        flash[:notice] = "Core(Comparison) cleaned successfully."
        redirect_to cores_path
    end

    def anything_btn
        # previously called franchiser_btn
        # !! CAUTION !!
        # @service.core_data_dumper
        # @service.delay.core_full_address_cleaner
        # @service.core_full_address_cleaner
        # @service.core_acct_name_cleaner

        # @service.phone_formatter

        # @service.geo_missing_street_num

        # @service.image_mover

        # @service.hybrid_address_matcher

        # @service.account_matcher

        # @service.core_staffer_domain_cleaner
        @service.delay.core_staffer_domain_cleaner



        # @service.period_remover


        ### Above are Dangerous!  Use w/ Care!  ###
        #############################

        # @service.core_root_formatter

        # @service.delay.franchise_resetter
        # @service.franchise_resetter
        # @service.delay.franchise_termer
        # @service.franchise_termer
        # @service.delay.franchise_consolidator
        # @service.franchise_consolidator

        # redirect_to root_path
        redirect_to cores_path

    end

    def col_splitter_btn
        @service.col_splitter
        redirect_to root_path
    end

    def merge_data
        @service.merge_data_starter(params[:cores])
        flash[:notice] = "Merging Data Done!"
        redirect_to cores_path
    end

    def flag_data
        @service.flag_data_starter(params[:cores])
        flash[:notice] = "Flagging Data Done!"
        redirect_to cores_path
    end

    def drop_data
        @service.drop_data_starter(params[:cores])
        flash[:notice] = "Dropping Data Done!"
        redirect_to cores_path
    end


    private
    # Use callbacks to share common setup or constraints between actions.
    def set_core
        @core = Core.find(params[:id])
    end

    def set_core_service
        @service = CoreService.new
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def core_params
        params.require(:core).permit(:bds_status, :sfdc_id, :sfdc_tier, :sfdc_sales_person, :sfdc_type, :sfdc_ult_grp, :sfdc_group, :sfdc_acct, :sfdc_street, :sfdc_city, :sfdc_state, :sfdc_ph, :sfdc_url, :created_at, :updated_at, :indexer_date, :staffer_date, :staff_pf_sts, :loc_pf_sts, :staff_link, :staff_text, :location_link, :location_text, :staffer_sts, :sfdc_franchise, :sfdc_franch_cat, :sfdc_franch_cons, :template, :full_address, :latitude, :longitude, :geo_date, :coordinates, :geo_sts, :cop_franch, :conf_cat, :sfdc_acct_url, :sfdc_ult_grp_id, :sfdc_group_id, :img_url, :sfdc_ult_rt, :sfdc_grp_rt, :sfdc_zip, :sfdc_clean_url, :crm_acct_pin, :crm_phones, :who_sts, :match_score, :acct_match_sts, :ph_match_sts, :pin_match_sts, :url_match_sts, :acct_merge_sts, :alt_acct_pin, :alt_acct, :alt_street, :alt_city, :alt_state, :alt_zip, :alt_ph, :alt_url, :alt_source, :alt_address, :alt_template, :redirect_sts)
    end

    def filtering_params(params)
        params.slice(:bds_status, :sfdc_id, :sfdc_tier, :sfdc_sales_person, :sfdc_type, :sfdc_ult_grp, :sfdc_group, :sfdc_acct, :sfdc_street, :sfdc_city, :sfdc_state, :sfdc_ph, :staff_pf_sts, :loc_pf_sts, :staffer_sts, :sfdc_franchise, :sfdc_franch_cat, :sfdc_franch_cons, :template, :full_address, :coordinates, :geo_sts, :cop_franch, :conf_cat, :sfdc_zip, :sfdc_clean_url, :crm_acct_pin, :crm_phones, :who_sts, :match_score, :acct_match_sts, :ph_match_sts, :pin_match_sts, :url_match_sts, :acct_merge_sts, :redirect_sts)
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
            if status == 'Queue Indexer'
                start_indexer(ids)
            elsif status == 'Queue Staffer'
                start_staffer(ids)
            elsif status == 'Queue Geo'
                geo_starter(ids)
            end
        end
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
