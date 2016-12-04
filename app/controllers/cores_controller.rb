class CoresController < ApplicationController
    before_action :set_core, only: [:show, :edit, :update, :destroy]

    # GET /cores
    # GET /cores.json
    def index
        if choice_hash = get_selected_status_core
            clean_choice_hash = {}
            choice_hash.each do |key, value|
                clean_choice_hash[key] = value if !value.nil?
            end
            @selected_data = Core.where(clean_choice_hash)
        else # choice_hash is nil
            @selected_data = Core.all
        end

        @cores = @selected_data.filter(filtering_params(params)).paginate(:page => params[:page], :per_page => 200)

        @cores_csv = @selected_data.order(:sfdc_id)
            respond_to do |format|
              format.html
              format.csv { render text: @cores_csv.to_csv }
        end

        # Exclude selected columns
        if params[:columns].present?
            columns = params[:columns]
            @col_bds_status = true if columns.include?("bds_status")
            @col_core_date = true if columns.include?("core_date")
            @col_domainer_date = true if columns.include?("domainer_date")
            @col_indexer_date = true if columns.include?("indexer_date")
            @col_staffer_date = true if columns.include?("staffer_date")
            @col_whois_date = true if columns.include?("whois_date")
            @col_sfdc_id = true if columns.include?("sfdc_id")
            @col_sfdc_tier = true if columns.include?("sfdc_tier")
            @col_sfdc_sales_person = true if columns.include?("sfdc_sales_person")
            @col_sfdc_type = true if columns.include?("sfdc_type")
            @col_sfdc_ult_rt = true if columns.include?("sfdc_ult_rt")
            @col_sfdc_grp_rt = true if columns.include?("sfdc_grp_rt")
            @col_sfdc_ult_grp = true if columns.include?("sfdc_ult_grp")
            @col_sfdc_group = true if columns.include?("sfdc_group")
            @col_sfdc_acct = true if columns.include?("sfdc_acct")
            @col_sfdc_street = true if columns.include?("sfdc_street")
            @col_sfdc_city = true if columns.include?("sfdc_city")
            @col_sfdc_state = true if columns.include?("sfdc_state")
            @col_sfdc_zip = true if columns.include?("sfdc_zip")
            @col_sfdc_ph = true if columns.include?("sfdc_ph")
            @col_sfdc_url = true if columns.include?("sfdc_url")
            @col_matched_url = true if columns.include?("matched_url")
            @col_matched_root = true if columns.include?("matched_root")
            @col_url_comparison = true if columns.include?("url_comparison")
            @col_root_comparison = true if columns.include?("root_comparison")
            @col_sfdc_root = true if columns.include?("sfdc_root")

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

    def batch_status
        unless params[:status_checks].nil?
            for id in params[:status_checks]
                data = Core.find(id)
                data.update_attribute(:bds_status, params[:selected_status])
            end
            # Queue
            if params[:selected_status] == 'Queue'
                start_queue(params[:status_checks])
            end
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_core
        @core = Core.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def core_params
        params.require(:core).permit(:bds_status, :sfdc_id, :sfdc_tier, :sfdc_sales_person, :sfdc_type, :sfdc_ult_rt, :sfdc_grp_rt, :sfdc_ult_grp, :sfdc_group, :sfdc_acct, :sfdc_street, :sfdc_city, :sfdc_state, :sfdc_zip, :sfdc_ph, :sfdc_url, :matched_url, :matched_root, :url_comparison, :root_comparison, :sfdc_root)
    end

    def filtering_params(params)
        params.slice(:bds_status, :sfdc_id, :sfdc_tier, :sfdc_sales_person, :sfdc_type, :sfdc_ult_rt, :sfdc_grp_rt, :sfdc_ult_grp, :sfdc_group, :sfdc_acct, :sfdc_street, :sfdc_city, :sfdc_state, :sfdc_zip, :sfdc_ph, :sfdc_url, :matched_url, :matched_root, :url_comparison, :root_comparison, :sfdc_root)
    end

    def start_queue(ids)
        # CoreService.new.delay.scrape_listing(ids)
        CoreService.new.scrape_listing(ids)
        flash[:notice] = 'Scraping queued!'
        redirect_to gcses_path
    end
end
