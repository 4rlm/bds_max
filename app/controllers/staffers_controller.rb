class StaffersController < ApplicationController
  before_action :set_staffer, only: [:show, :edit, :update, :destroy]
  before_action :set_staffer_service, only: [:staffer_sfdc_id_cleaner_btn, :cs_data_getter_btn]

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
        @selected_data = Staffer.all.order
    end

    if url = params[:url]
        @selected_data = @selected_data.where(domain: url).order(updated_at: :desc)
    else
        @selected_data = @selected_data.order(updated_at: :desc)
    end
    @staffer_count = Staffer.count
    @selected_staffer_count = @selected_data.count

    respond_to do |format|
        format.html
        format.csv { render text: @selected_data.to_csv }
    end

    # Original !!!
    # @paginate_staffers = @staffers.filter(filtering_params(params))

    #---------  Adam's Trial 1 w/ Filters- Starts
    @staffers = @selected_data.filter(filtering_params(params)).paginate(:page => params[:page], :per_page => 100)
    #---------  Adam's Trial 1 - Ends -------

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
        @staffers = Staffer.where(domain: @core.sfdc_url)

    end


    def staffer_sfdc_id_cleaner_btn
        # @staffer_service.staffer_sfdc_id_cleaner

        # @staffer_service.staffer_core_updater
        @staffer_service.delay.staffer_core_updater


        redirect_to root_path
    end


    def cs_data_getter_btn
        @staffer_service.cs_data_getter
      #   @staffer_service.delay.cs_data_getter
        redirect_to indexers_path
    end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_staffer
      @staffer = Staffer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def staffer_params
      params.require(:staffer).permit(:staffer_status, :cont_status, :cont_source, :sfdc_id, :sfdc_sales_person, :sfdc_type, :sfdc_cont_id, :template, :staffer_date, :created_at, :updated_at, :staff_link, :staff_text, :sfdc_cont_active, :sfdc_tier, :domain, :acct_name, :group_name, :ult_group_name, :street, :city, :state, :zip, :fname, :lname, :fullname, :job, :job_raw, :phone, :email, :influence, :cell_phone, :last_activity_date, :created_date, :updated_date, :franchise)
    end

      def filtering_params(params)
          params.slice(:staffer_status, :cont_status, :cont_source, :sfdc_id, :sfdc_sales_person, :sfdc_type, :sfdc_cont_id, :template, :staffer_date, :created_at, :updated_at, :staff_link, :staff_text, :sfdc_cont_active, :sfdc_tier, :domain, :acct_name, :group_name, :ult_group_name, :street, :city, :state, :zip, :fname, :lname, :fullname, :job, :job_raw, :phone, :email, :influence, :cell_phone, :last_activity_date, :created_date, :updated_date, :franchise, :coordinates, :full_address, :franch_cat)
        end



    def batch_status
        ids = params[:multi_checks]
        return if ids.nil?
        status = params[:selected_status]
        for id in ids
            staff = Staffer.find(id)
            staff.update_attribute(:staffer_status, status)
            flash[:notice] = "Successfully updated"

            # *** Uncomment after Core Migration new staffer columns
            # core = Core.find_by(sfdc_id: staffer.sfdc_id)
            # core.update_attribute(:staffer_status, status)
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
