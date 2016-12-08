class IndexerStaffsController < ApplicationController
  before_action :set_indexer_staff, only: [:show, :edit, :update, :destroy]

  # GET /indexer_staffs
  # GET /indexer_staffs.json
  def index
    @indexer_staffs = IndexerStaff.order(:domain)
    respond_to do |format|
        format.html
        format.csv { render text: @indexer_staffs.to_csv }
    end


    #==== For multi check box
    selects = params[:multi_checks]
    unless selects.nil?
        IndexerStaff.where(id: selects).destroy_all
    end
    #================

  end

  # GET /indexer_staffs/1
  # GET /indexer_staffs/1.json
  def show
  end

  # GET /indexer_staffs/new
  def new
    @indexer_staff = IndexerStaff.new
  end


  # Go to the CSV importing page
  def import_page
  end

  def import_csv_data
      file_name = params[:file]
      IndexerStaff.import_csv(file_name)

      flash[:notice] = "CSV imported successfully."
      redirect_to indexer_staffs_path
  end


  # GET /indexer_staffs/1/edit
  def edit
  end

  # POST /indexer_staffs
  # POST /indexer_staffs.json
  def create
    @indexer_staff = IndexerStaff.new(indexer_staff_params)

    respond_to do |format|
      if @indexer_staff.save
        format.html { redirect_to @indexer_staff, notice: 'Indexer staff was successfully created.' }
        format.json { render :show, status: :created, location: @indexer_staff }
      else
        format.html { render :new }
        format.json { render json: @indexer_staff.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /indexer_staffs/1
  # PATCH/PUT /indexer_staffs/1.json
  def update
    respond_to do |format|
      if @indexer_staff.update(indexer_staff_params)
        format.html { redirect_to @indexer_staff, notice: 'Indexer staff was successfully updated.' }
        format.json { render :show, status: :ok, location: @indexer_staff }
      else
        format.html { render :edit }
        format.json { render json: @indexer_staff.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /indexer_staffs/1
  # DELETE /indexer_staffs/1.json
  def destroy
    @indexer_staff.destroy
    respond_to do |format|
      format.html { redirect_to indexer_staffs_url, notice: 'Indexer staff was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_indexer_staff
      @indexer_staff = IndexerStaff.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def indexer_staff_params
      params.require(:indexer_staff).permit(:indexer_status, :sfdc_acct, :sfdc_group_name, :sfdc_ult_acct, :root, :domain, :ip, :text, :href, :staff_link, :msg, :sfdc_street, :sfdc_city, :sfdc_state, :sfdc_type, :sfdc_tier, :sfdc_sales_person, :sfdc_id, :indexer_timestamp)
    end
end
