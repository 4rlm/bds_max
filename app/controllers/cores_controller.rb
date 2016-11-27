class CoresController < ApplicationController
    before_action :set_core, only: [:show, :edit, :update, :destroy]

    # GET /cores
    # GET /cores.json
    def index
        # @coresp = Core.all
        # @coresp = Core.paginate(:page => params[:page], :per_page => 5)

        if status = get_selected_status_core
            @selected_data = Core.where(bds_status: status)
        else # status is nil
            @selected_data = Core.all
        end

        @cores = @selected_data.filter(filtering_params(params)).paginate(:page => params[:page], :per_page => 100)

        # @cores = Core.filter(filtering_params(params))

        # Exclude selected columns
        if params[:columns].present?
            columns = params[:columns]
            @col_bds_status = true if columns.include?("bds_status")
            @col_sfdc_id = true if columns.include?("sfdc_id")
            @col_sfdc_ult_grp = true if columns.include?("sfdc_ult_grp")
            @col_sfdc_acct = true if columns.include?("sfdc_acct")
            @col_sfdc_type = true if columns.include?("sfdc_type")
            @col_sfdc_street = true if columns.include?("sfdc_street")
            @col_sfdc_city = true if columns.include?("sfdc_city")
            @col_sfdc_state = true if columns.include?("sfdc_state")
            @col_sfdc_url = true if columns.include?("sfdc_url")
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
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_core
        @core = Core.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def core_params
        params.require(:core).permit(:bds_status, :sfdc_id, :sfdc_tier, :sfdc_sales_person, :sfdc_type, :sfdc_ult_grp, :sfdc_ult_rt, :sfdc_group, :sfdc_grp_rt, :sfdc_acct, :sfdc_street, :sfdc_city, :sfdc_state, :sfdc_zip, :sfdc_ph, :sfdc_url)
    end

    def filtering_params(params)
        params.slice(:bds_status, :sfdc_id, :sfdc_tier, :sfdc_sales_person, :sfdc_type, :sfdc_ult_grp, :sfdc_ult_rt, :sfdc_group, :sfdc_grp_rt, :sfdc_acct, :sfdc_street, :sfdc_city, :sfdc_state, :sfdc_zip, :sfdc_ph, :sfdc_url)
    end

end
