class StaffersController < ApplicationController
    before_action :intermediate_and_up, only: [:index, :show, :search, :acct_contacts]
    before_action :advanced_and_up, only: [:edit, :update]
    before_action :admin_only, only: [:new, :create, :destroy, :import_page, :import_csv_data, :staffer_sfdc_id_cleaner_btn, :cs_data_getter_btn, :temporary_btn]
    before_action :set_staffer, only: [:show, :edit, :update, :destroy]
    before_action :set_staffer_service, only: [:staffer_sfdc_id_cleaner_btn, :cs_data_getter_btn, :temporary_btn]

    # GET /staffers
    # GET /staffers.json

    def index
        if choice_hash = get_selected_status_staffer
            clean_choice_hash = {}
            @view_mode = choice_hash[:view_mode]

            choice_hash.each do |key, value|
                clean_choice_hash[key] = value if !value.nil? && value != "" && key != :view_mode
            end
            @selected_data = Staffer.where(clean_choice_hash)
        else # choice_hash is nil
            @selected_data = Staffer.all.order(updated_at: :desc)
        end

        if url = params[:url]
            @selected_data = @selected_data.where(domain: url).order(updated_at: :desc)
        else
            @selected_data = @selected_data.order(updated_at: :desc)
        end
        @staffer_count = Staffer.count
        @selected_staffer_count = @selected_data.count


        # Get dropdown option list from Dashboard
        @cont_source_opts = Dashboard.find_by(db_name: "Staffer", col_name: "cont_source").item_list
        @cont_status_opts = Dashboard.find_by(db_name: "Staffer", col_name: "cont_status").item_list
        @sfdc_sales_person_opts = Dashboard.find_by(db_name: "Staffer", col_name: "sfdc_sales_person").item_list
        @sfdc_tier_opts = Dashboard.find_by(db_name: "Staffer", col_name: "sfdc_tier").item_list
        @sfdc_type_opts = Dashboard.find_by(db_name: "Staffer", col_name: "sfdc_type").item_list
        @staffer_sts_opts = Dashboard.find_by(db_name: "Staffer", col_name: "staffer_sts").item_list


        # CSV #
        respond_to do |format|
            format.html
            format.csv { render text: @selected_data.to_csv }
        end

        @staffers = @selected_data.filter(filtering_params(params)).paginate(:page => params[:page], :per_page => 100)

        batch_status
    end

    # GET /staffers/1
    # GET /staffers/1.json
    def show
    end

    # GET /staffers/new
    def new
        @staffer = Staffer.new
    end

    # Go to the CSV importing page
    def import_page
    end

    def import_csv_data
        file_name = params[:file]
        Staffer.import_csv(file_name)

        flash[:notice] = "CSV imported successfully."
        redirect_to staffers_path
    end


    # GET /staffers/1/edit
    def edit
    end

    def search
        @staffer_count = Staffer.count
    end


    # POST /staffers
    # POST /staffers.json
    def create
        @staffer = Staffer.new(staffer_params)

        respond_to do |format|
            if @staffer.save
                format.html { redirect_to @staffer, notice: 'Staffer was successfully created.' }
                format.json { render :show, status: :created, location: @staffer }
            else
                format.html { render :new }
                format.json { render json: @staffer.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /staffers/1
    # PATCH/PUT /staffers/1.json
    def update
        respond_to do |format|
            if @staffer.update(staffer_params)
                format.html { redirect_to @staffer, notice: 'Staffer was successfully updated.' }
                format.json { render :show, status: :ok, location: @staffer }
            else
                format.html { render :edit }
                format.json { render json: @staffer.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /staffers/1
    # DELETE /staffers/1.json
    def destroy
        @staffer.destroy
        respond_to do |format|
            format.html { redirect_to staffers_url, notice: 'Staffer was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    def acct_contacts
        @core = Core.find(params[:core])
        # @staffers = Staffer.where(sfdc_id: @core.sfdc_id)
        @staffers = Staffer.where(domain: @core.sfdc_clean_url)
    end


    def staffer_sfdc_id_cleaner_btn
        # @staffer_service.staffer_sfdc_id_cleaner

        # @staffer_service.staffer_core_updater
        # @staffer_service.delay.staffer_core_updater


        redirect_to root_path
    end


    def cs_data_getter_btn
        # @staffer_service.cs_data_getter
        @staffer_service.delay.cs_data_getter

        redirect_to indexers_path
    end


    # ========== Temporary/Power Button ==========

    def temporary_btn
        # @staffer_service.fname_cleaner
        # @staffer_service.delay.fname_cleaner

        redirect_to indexers_path
    end


    private
    # Use callbacks to share common setup or constraints between actions.
    def set_staffer
        @staffer = Staffer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def staffer_params
        params.require(:staffer).permit(:staffer_sts, :cont_status, :cont_source, :sfdc_id, :sfdc_sales_person, :sfdc_type, :sfdc_cont_id, :staffer_date, :created_at, :updated_at, :sfdc_tier, :domain, :acct_name, :street, :city, :state, :zip, :fname, :lname, :fullname, :job, :job_raw, :phone, :email, :full_address, :acct_pin, :cont_pin)
    end

    def filtering_params(params)
        params.slice(:staffer_sts, :cont_status, :cont_source, :sfdc_id, :sfdc_sales_person, :sfdc_type, :sfdc_cont_id, :staffer_date, :created_at, :updated_at, :sfdc_tier, :domain, :acct_name, :street, :city, :state, :zip, :fname, :lname, :fullname, :job, :job_raw, :phone, :email, :full_address, :acct_pin, :cont_pin)
    end

    def batch_status
        ids = params[:multi_checks]
        return if ids.nil?
        status = params[:selected_status]
        for id in ids
            staff = Staffer.find(id)
            staff.update_attribute(:staffer_sts, status)
            flash[:notice] = "Successfully updated"

            # *** Uncomment after Core Migration new staffer columns
            # core = Core.find_by(sfdc_id: staffer.sfdc_id)
            # core.update_attribute(:staffer_sts, status)
        end

        destroy_rows(ids) if status == "Destroy"
    end

    def destroy_rows(ids)
        rows = Staffer.where(id: ids)
        rows.destroy_all
    end

    def set_staffer_service
        @staffer_service = StafferService.new
    end

end
