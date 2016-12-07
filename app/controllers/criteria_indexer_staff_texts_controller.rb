class CriteriaIndexerStaffTextsController < ApplicationController
  before_action :set_criteria_indexer_staff_text, only: [:show, :edit, :update, :destroy]

  # GET /criteria_indexer_staff_texts
  # GET /criteria_indexer_staff_texts.json
  def index
    @criteria_indexer_staff_texts = CriteriaIndexerStaffText.order(:term)
    respond_to do |format|
          format.html
          format.csv { render text: @CriteriaIndexerStaffText.to_csv }
      end

  #==== For multi check box
  selects = params[:multi_checks]
  unless selects.nil?
      CriteriaIndexerStaffText.where(id: selects).destroy_all
  end
  #================

end

  # GET /criteria_indexer_staff_texts/1
  # GET /criteria_indexer_staff_texts/1.json
  def show
  end

  # GET /criteria_indexer_staff_texts/new
  def new
    @criteria_indexer_staff_text = CriteriaIndexerStaffText.new
  end


  # Go to the CSV importing page
  def import_page
  end

  def import_csv_data
    file_name = params[:file]
    CriteriaIndexerStaffText.import_csv(file_name)

    flash[:notice] = "CSV imported successfully."
    redirect_to criteria_indexer_staff_texts_path
  end


  # GET /criteria_indexer_staff_texts/1/edit
  def edit
  end

  # POST /criteria_indexer_staff_texts
  # POST /criteria_indexer_staff_texts.json
  def create
    @criteria_indexer_staff_text = CriteriaIndexerStaffText.new(criteria_indexer_staff_text_params)

    respond_to do |format|
      if @criteria_indexer_staff_text.save
        format.html { redirect_to @criteria_indexer_staff_text, notice: 'Criteria indexer staff text was successfully created.' }
        format.json { render :show, status: :created, location: @criteria_indexer_staff_text }
      else
        format.html { render :new }
        format.json { render json: @criteria_indexer_staff_text.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /criteria_indexer_staff_texts/1
  # PATCH/PUT /criteria_indexer_staff_texts/1.json
  def update
    respond_to do |format|
      if @criteria_indexer_staff_text.update(criteria_indexer_staff_text_params)
        format.html { redirect_to @criteria_indexer_staff_text, notice: 'Criteria indexer staff text was successfully updated.' }
        format.json { render :show, status: :ok, location: @criteria_indexer_staff_text }
      else
        format.html { render :edit }
        format.json { render json: @criteria_indexer_staff_text.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /criteria_indexer_staff_texts/1
  # DELETE /criteria_indexer_staff_texts/1.json
  def destroy
    @criteria_indexer_staff_text.destroy
    respond_to do |format|
      format.html { redirect_to criteria_indexer_staff_texts_url, notice: 'Criteria indexer staff text was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_criteria_indexer_staff_text
      @criteria_indexer_staff_text = CriteriaIndexerStaffText.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def criteria_indexer_staff_text_params
      params.require(:criteria_indexer_staff_text).permit(:term)
    end
end
