class CoresController < ApplicationController
    before_action :set_core, only: [:show, :edit, :update, :destroy]

    # GET /cores
    # GET /cores.json
    def index
        if choice_hash = get_selected_status_core
            clean_choice_hash = {}
            choice_hash.each do |key, value|
                clean_choice_hash[key] = value if !value.nil? && value != ""
            end
            @selected_data = Core.where(clean_choice_hash)
        else # choice_hash is nil
            @selected_data = Core.all
        end

        # @cores = @selected_data.filter(filtering_params(params)).limit(20)

        # @cores_limited = @selected_data.limit(20)


        @cores = @selected_data.filter(filtering_params(params)).paginate(:page => params[:page], :per_page => 30)


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
        CoreService.new.core_comp_cleaner_btn
        flash[:notice] = "Core(Comparison) cleaned successfully."
        redirect_to cores_path
    end

    def quick_core_view_queue
        set_selected_status_core({"bds_status"=>["Queue Domainer"]})

        redirect_to cores_path
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
        params.require(:core).permit(:bds_status, :staff_indexer_status, :location_indexer_status, :inventory_indexer_status, :staffer_status, :sfdc_id, :sfdc_tier, :sfdc_sales_person, :sfdc_type, :sfdc_ult_rt, :sfdc_grp_rt, :sfdc_ult_grp, :sfdc_group, :sfdc_acct, :sfdc_street, :sfdc_city, :sfdc_state, :sfdc_zip, :sfdc_ph, :sfdc_url, :matched_url, :matched_root, :url_comparison, :root_comparison, :sfdc_root)
    end

    def filtering_params(params)
        params.slice(:bds_status, :staff_indexer_status, :location_indexer_status, :inventory_indexer_status, :staffer_status, :sfdc_id, :sfdc_tier, :sfdc_sales_person, :sfdc_type, :sfdc_ult_rt, :sfdc_grp_rt, :sfdc_ult_grp, :sfdc_group, :sfdc_acct, :sfdc_street, :sfdc_city, :sfdc_state, :sfdc_zip, :sfdc_ph, :sfdc_url, :matched_url, :matched_root, :url_comparison, :root_comparison, :sfdc_root)
    end

    def start_domainer(ids)
        CoreService.new.delay.scrape_listing(ids)
        # CoreService.new.scrape_listing(ids)
        flash[:notice] = 'Domainer started!'
        redirect_to gcses_path
    end

    def start_indexer(ids)
        IndexerService.new.delay.start_indexer(ids)
        # IndexerService.new.start_indexer(ids)
        flash[:notice] = 'Indexer started!'
        redirect_to indexer_staffs_path
    end

    def start_staffer(ids)
        # StafferService.new.delay.start_staffer(ids)
        StafferService.new.start_staffer(ids)

        flash[:notice] = 'Staffer started!'
        redirect_to staffers_path
    end

end
