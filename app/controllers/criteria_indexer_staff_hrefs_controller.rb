class CriteriaIndexerStaffHrefsController < ApplicationController
  before_action :set_criteria_indexer_staff_href, only: [:show, :edit, :update, :destroy]

  # GET /criteria_indexer_staff_hrefs
  # GET /criteria_indexer_staff_hrefs.json
  def index
    @criteria_indexer_staff_hrefs = CriteriaIndexerStaffHref.order(:term)
    respond_to do |format|
          format.html
          format.csv { render text: @criteria_indexer_staff_hrefs.to_csv }
      end

  #==== For multi check box
  selects = params[:multi_checks]
  unless selects.nil?
      CriteriaIndexerStaffHref.where(id: selects).destroy_all
  end
  #================

end

  # GET /criteria_indexer_staff_hrefs/1
  # GET /criteria_indexer_staff_hrefs/1.json
  def show
  end

  # GET /criteria_indexer_staff_hrefs/new
  def new
    @criteria_indexer_staff_href = CriteriaIndexerStaffHref.new
  end


  # Go to the CSV importing page
  def import_page
  end

  def import_csv_data
    file_name = params[:file]
    CriteriaIndexerStaffHref.import_csv(file_name)

    flash[:notice] = "CSV imported successfully."
    redirect_to criteria_indexer_staff_hrefs_path
  end


  # GET /criteria_indexer_staff_hrefs/1/edit
  def edit
  end

  # POST /criteria_indexer_staff_hrefs
  # POST /criteria_indexer_staff_hrefs.json
  def create
    @criteria_indexer_staff_href = CriteriaIndexerStaffHref.new(criteria_indexer_staff_href_params)

    respond_to do |format|
      if @criteria_indexer_staff_href.save
        format.html { redirect_to @criteria_indexer_staff_href, notice: 'Criteria indexer staff href was successfully created.' }
        format.json { render :show, status: :created, location: @criteria_indexer_staff_href }
      else
        format.html { render :new }
        format.json { render json: @criteria_indexer_staff_href.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /criteria_indexer_staff_hrefs/1
  # PATCH/PUT /criteria_indexer_staff_hrefs/1.json
  def update
    respond_to do |format|
      if @criteria_indexer_staff_href.update(criteria_indexer_staff_href_params)
        format.html { redirect_to @criteria_indexer_staff_href, notice: 'Criteria indexer staff href was successfully updated.' }
        format.json { render :show, status: :ok, location: @criteria_indexer_staff_href }
      else
        format.html { render :edit }
        format.json { render json: @criteria_indexer_staff_href.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /criteria_indexer_staff_hrefs/1
  # DELETE /criteria_indexer_staff_hrefs/1.json
  def destroy
    @criteria_indexer_staff_href.destroy
    respond_to do |format|
      format.html { redirect_to criteria_indexer_staff_hrefs_url, notice: 'Criteria indexer staff href was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_criteria_indexer_staff_href
      @criteria_indexer_staff_href = CriteriaIndexerStaffHref.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def criteria_indexer_staff_href_params
      params.require(:criteria_indexer_staff_href).permit(:term)
    end
end