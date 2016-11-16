class GcsesController < ApplicationController
    before_action :set_gcse, only: [:show, :edit, :update, :destroy]

    # GET /gcses
    # GET /gcses.json
    def index
        # @gcsesp = Gcse.all
        # @gcsesp = Gcse.paginate(:page => params[:page], :per_page => 5)
        @selected_data = Gcse.where(domain_status: get_selected_status)

        @gcses = @selected_data.filter(filtering_params(params)).paginate(:page => params[:page], :per_page => 100)

        # @gcses = Gcse.filter(filtering_params(params))

        # Exclude selected columns
        if params[:columns].present?
            columns = params[:columns]
            @col_domain_status = true if columns.include?("domain_status")
            @col_gcse_timestamp = true if columns.include?("gcse_timestamp")
            @col_gcse_query_num = true if columns.include?("gcse_query_num")
            @col_gcse_result_num = true if columns.include?("gcse_result_num")
            @col_sfdc_id = true if columns.include?("sfdc_id")
            @col_sfdc_ult_acct = true if columns.include?("sfdc_ult_acct")
            @col_sfdc_acct = true if columns.include?("sfdc_acct")
            @col_sfdc_type = true if columns.include?("sfdc_type")
            @col_sfdc_street = true if columns.include?("sfdc_street")
            @col_sfdc_city = true if columns.include?("sfdc_city")
            @col_sfdc_state = true if columns.include?("sfdc_state")
            @col_sfdc_url_o = true if columns.include?("sfdc_url_o")
            @col_domain = true if columns.include?("domain")
            @col_root = true if columns.include?("root")
            @col_suffix = true if columns.include?("suffix")
            @col_in_host_pos = true if columns.include?("in_host_pos")
            @col_in_host_neg = true if columns.include?("in_host_neg")
            @col_in_host_del = true if columns.include?("in_host_del")
            @col_in_suffix_del = true if columns.include?("in_suffix_del")
            @col_exclude_root = true if columns.include?("exclude_root")
            @col_text = true if columns.include?("text")
            @col_in_text_pos = true if columns.include?("in_text_pos")
            @col_in_text_neg = true if columns.include?("in_text_neg")
            @col_in_text_del = true if columns.include?("in_text_del")
            @col_url_encoded = true if columns.include?("url_encoded")
        end

        # Checkbox
        batch_status
    end

    # GET /gcses/1
    # GET /gcses/1.json
    def show
    end

    # GET /gcses/new
    def new
        @gcse = Gcse.new
    end

    def import_page
    end

    def import
      file_name = params[:file]
      Gcse.import_csv(file_name)

      flash[:notice] = "CSV imported successfully."
      redirect_to gcses_path
    end

    # GET /gcses/1/edit
    def edit
    end

    # POST /gcses
    # POST /gcses.json
    def create
        @gcse = Gcse.new(gcse_params)

        respond_to do |format|
            if @gcse.save
                format.html { redirect_to @gcse, notice: 'Gcse was successfully created.' }
                format.json { render :show, status: :created, location: @gcse }
            else
                format.html { render :new }
                format.json { render json: @gcse.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /gcses/1
    # PATCH/PUT /gcses/1.json
    def update
        respond_to do |format|
            if @gcse.update(gcse_params)
                format.html { redirect_to @gcse, notice: 'Gcse was successfully updated.' }
                format.json { render :show, status: :ok, location: @gcse }
            else
                format.html { render :edit }
                format.json { render json: @gcse.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /gcses/1
    # DELETE /gcses/1.json
    def destroy
        @gcse.destroy
        respond_to do |format|
            format.html { redirect_to gcses_url, notice: 'Gcse was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    def batch_status
        unless params[:status_checks].nil?
            for id in params[:status_checks]
                data = Gcse.find(id)
                data.update_attribute(:domain_status, params[:selected_status])
            end
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_gcse
        @gcse = Gcse.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gcse_params
        params.require(:gcse).permit(:domain_status, :gcse_timestamp, :gcse_query_num, :gcse_result_num, :sfdc_id, :sfdc_ult_acct, :sfdc_acct, :sfdc_type, :sfdc_street, :sfdc_city, :sfdc_state, :sfdc_url_o, :domain, :root, :suffix, :in_host_pos, :in_host_neg, :in_host_del, :in_suffix_del, :exclude_root, :text, :in_text_pos, :in_text_neg, :in_text_del, :url_encoded)
    end

    def filtering_params(params)
        params.slice(:domain_status, :gcse_timestamp, :gcse_query_num, :gcse_result_num, :sfdc_id, :sfdc_ult_acct, :sfdc_acct, :sfdc_type, :sfdc_street, :sfdc_city, :sfdc_state, :sfdc_url_o, :domain, :root, :suffix, :in_host_pos, :in_host_neg, :in_host_del, :in_suffix_del, :exclude_root, :text, :in_text_pos, :in_text_neg, :in_text_del, :url_encoded)
    end

end
