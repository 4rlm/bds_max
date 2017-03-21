class IndexersController < ApplicationController
    before_action :intermediate_and_up, only: [:index, :show]
    before_action :advanced_and_up, only: [:edit, :update]
    before_action :admin_only, only: [:new, :create, :destroy, :import_page, :import_csv_data, :indexer_power_btn, :reset_errors_btn, :page_finder_btn, :template_finder_btn, :rooftop_data_getter_btn, :meta_scraper_btn]
    before_action :set_indexer, only: [:show, :edit, :update, :destroy]
    before_action :set_indexer_service, only: [:page_finder_btn, :reset_errors_btn, :indexer_power_btn, :template_finder_btn, :rooftop_data_getter_btn, :meta_scraper_btn, :url_redirect_checker_btn]
    before_action :set_option_list, only: [:index, :search]


    # GET /indexers
    # GET /indexers.json
    def index

        @indexers = Indexer.all

        if params[:score100_check] == "true"
            @indexers = @indexers.where.not("score100 = '{}'")
        end
        if params[:score75_check] == "true"
            @indexers = @indexers.where.not("score75 = '{}'")
        end
        if params[:score50_check] == "true"
            @indexers = @indexers.where.not("score50 = '{}'")
        end
        if params[:score25_check] == "true"
            @indexers = @indexers.where.not("score25 = '{}'")
        end


        ## SET ORDER OF DISPLAYED DATA ##
        @indexers = @indexers.order(updated_at: :desc)

        @indexers_count = Indexer.count
        @selected_indexers_count = @indexers.count

        # CSV #
        indexers_csv = @indexers.order(:clean_url)
        respond_to do |format|
            format.html
            format.csv { render text: indexers_csv.to_csv }
        end

        # @indexers = @indexers.paginate(:page => params[:page], :per_page => 100)

        # WILL_PAGINATE #
        @indexers = @indexers.filter(filtering_params(params)).paginate(:page => params[:page], :per_page => 50)


        batch_status
    end

    # GET /indexers/1
    # GET /indexers/1.json
    def show
    end

    # GET /indexers/new
    def new
        @indexer = Indexer.new
    end

    def import_page
    end

    def import_csv_data
        file_name = params[:file]
        Indexer.import_csv(file_name, Indexer, "indexer_status")

        flash[:notice] = "CSV imported successfully."
        redirect_to indexers_path
    end

    def search
        @indexer_count = Indexer.count
        @stf_status_opts = Dashboard.find_by(db_name: "Indexer", col_name: "stf_status").item_list
        @loc_status_opts = Dashboard.find_by(db_name: "Indexer", col_name: "loc_status").item_list
    end



    # GET /indexers/1/edit
    def edit
    end


    # POST /indexers
    # POST /indexers.json
    def create
        @indexer = Indexer.new(indexer_params)

        respond_to do |format|
            if @indexer.save
                format.html { redirect_to @indexer, notice: 'Indexer was successfully created.' }
                format.json { render :show, status: :created, location: @indexer }
            else
                format.html { render :new }
                format.json { render json: @indexer.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /indexers/1
    # PATCH/PUT /indexers/1.json
    def update
        respond_to do |format|
            if @indexer.update(indexer_params)
                format.html { redirect_to @indexer, notice: 'Indexer was successfully updated.' }
                format.json { render :show, status: :ok, location: @indexer }
            else
                format.html { render :edit }
                format.json { render json: @indexer.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /indexers/1
    # DELETE /indexers/1.json
    def destroy
        @indexer.destroy
        respond_to do |format|
            format.html { redirect_to indexers_url, notice: 'Indexer was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    def show_detail
        @core = Core.find(params[:core])
        @indexers = Indexer.where(clean_url: @core.sfdc_clean_url).where(archive: false)
    end




    ### =============== BUTTONS Start ===============

    def indexer_power_btn
        # @service.url_arr_extractor
        # @service.scraped_contacts_sts_checker
        # @service.count_contacts
        # @service.dup_url_cleaner
        # @service.delay.dup_url_cleaner
        # @service.staff_url_cleaner
        # @service.url_downcase
        # @service.delay.url_downcase
        # @service.hyrell_cleaner
        # @service.template_counter
        # @service.stafflink_express
        # @service.core_phone_norm
        # @service.core_url_redirect

        # @service.indexer_duplicate_purger
        # @service.db_data_trimmer

        # @service.delay.staff_phone_formatter

        # @service.job_title_migrator


        # @service.m_zip_remover

        # @service.pin_acct_counter
        # @service.junk_cleaner

        # @service.redirect_url_migrator

        # @service.delay.phones_arr_cleaner
        # @service.phones_arr_cleaner

        # @service.delay.ph_arr_mover_express


        # @service.indexer_mover

        # @service.delay.count_staff
        # @service.count_staff

        # @service.delay.count_staff
        # @service.count_staff

        # @service.delay.remove_invalid_phones
        # @service.remove_invalid_phones

        # @service.acct_pin_gen_starter
        # @service.acct_pin_gen_helper



        # @service.indexer_to_core
        # @service.delay.calculate_score
        @service.delay.indexer_mover
        # @service.indexer_mover


        redirect_to indexers_path
    end

    def url_redirect_checker_btn
        #  @service.url_redirect_checker
        @service.delay.url_redirect_checker
    end



    def reset_errors_btn
        # @service.reset_errors

        redirect_to indexers_path
    end


    def page_finder_btn
        @service.page_finder_starter
        # @service.delay.page_finder_starter
        #   @service.url_importer

        redirect_to indexers_path
    end

    def template_finder_btn
        #   @service.template_finder
        #   @service.delay.template_finder
        redirect_to indexers_path
    end


    def rooftop_data_getter_btn
          @service.rooftop_data_getter
        #   @service.delay.rooftop_data_getter

        redirect_to indexers_path
    end

    def meta_scraper_btn
        #   @service.meta_scraper
        @service.delay.meta_scraper

        redirect_to indexers_path
    end



    ### =============== BUTTONS End ===============




    private
    # Use callbacks to share common setup or constraints between actions.
    def set_indexer
        @indexer = Indexer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def indexer_params
        params.require(:indexer).permit( raw_url, :redirect_status, :clean_url, :indexer_status, :staff_url, :staff_text, :location_url, :location_text, :template, :crm_id_arr, :loc_status, :stf_status, :contact_status, :contacts_link, :acct_name, :rt_sts, :cont_sts, :full_addr, :street, :city, :state, :zip, :phone, :phones, :acct_pin, :raw_street, :who_status, :geo_status, :contacts_count, :clean_url_crm_ids, :acct_pin_crm_id, :archive, :crm_acct_ids, :crm_ph_ids, :score100, :score75, :score50, :score25, :rejected_ids, :flagged_ids, :dropped_ids, :bug, :bug_note, :cop_type, :cop_franchises, :flagged_note)
    end


    def filtering_params(params)
        params.slice(:raw_url, :redirect_status, :clean_url, :indexer_status, :template, :loc_status, :stf_status, :contact_status, :acct_name, :rt_sts, :cont_sts, :full_addr, :phone, :acct_pin, :who_status, :geo_status, :score100, :score75, :score50, :score25, :bug, :cop_type)
    end


    def set_indexer_service
        @service = IndexerService.new
    end


    def batch_status
        ids = params[:multi_checks]
        return if ids.nil?
        status = params[:selected_status]
        for id in ids
            indexer = Indexer.find(id)
            indexer.update_attribute(:indexer_status, status)
            flash[:notice] = "Successfully updated"

            # core = Core.find_by(sfdc_id: indexer.sfdc_id)
            # core.update_attribute(:loc_pf_sts, status)
        end

        destroy_rows(ids) if status == "Destroy"
    end

    def destroy_rows(ids)
        rows = Indexer.where(id: ids)
        rows.destroy_all
    end

    # Get dropdown option list from Dashboard
    def set_option_list
        @indexer_status_opts = grap_item_list("indexer_status")
        @redirect_status_opts = grap_item_list("redirect_status")
        @who_status_opts = grap_item_list("who_status")
        @template_opts = grap_item_list("template")
        @rt_sts_opts = grap_item_list("rt_sts")
        @stf_status_opts = grap_item_list("stf_status")
        @loc_status_opts = grap_item_list("loc_status")
        @contact_status_opts = grap_item_list("contact_status")
        @cont_sts_opts = grap_item_list("cont_sts")
        @state_opts = grap_item_list("state")
    end

    def grap_item_list(col_name)
        Dashboard.find_by(db_name: "Indexer", col_name: col_name).item_list
    end

end
