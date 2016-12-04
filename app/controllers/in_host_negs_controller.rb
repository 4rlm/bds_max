class InHostNegsController < ApplicationController
  before_action :set_in_host_neg, only: [:show, :edit, :update, :destroy]

  # GET /in_host_negs
  # GET /in_host_negs.json
  def index
    # @in_host_negs = InHostNeg.all

    @in_host_negs = InHostNeg.order(:term)
    respond_to do |format|
          format.html
          format.csv { render text: @in_host_negs.to_csv }
      end

    #==== For multi check box
    selects = params[:multi_checks]
    unless selects.nil?
        InHostNeg.where(id: selects).destroy_all
    end
    #================

  end

  # GET /in_host_negs/1
  # GET /in_host_negs/1.json
  def show
  end

  # GET /in_host_negs/new
  def new
    @in_host_neg = InHostNeg.new
  end

    # Go to the CSV importing page
    def import_page
    end

    def import_csv_data
      file_name = params[:file]
      InHostNeg.import_csv(file_name)

      flash[:notice] = "CSV imported successfully."
      redirect_to in_host_negs_path
    end

  # GET /in_host_negs/1/edit
  def edit
  end

  # POST /in_host_negs
  # POST /in_host_negs.json
  def create
    @in_host_neg = InHostNeg.new(in_host_neg_params)

    respond_to do |format|
      if @in_host_neg.save
        format.html { redirect_to @in_host_neg, notice: 'In host neg was successfully created.' }
        format.json { render :show, status: :created, location: @in_host_neg }
      else
        format.html { render :new }
        format.json { render json: @in_host_neg.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /in_host_negs/1
  # PATCH/PUT /in_host_negs/1.json
  def update
    respond_to do |format|
      if @in_host_neg.update(in_host_neg_params)
        format.html { redirect_to @in_host_neg, notice: 'In host neg was successfully updated.' }
        format.json { render :show, status: :ok, location: @in_host_neg }
      else
        format.html { render :edit }
        format.json { render json: @in_host_neg.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /in_host_negs/1
  # DELETE /in_host_negs/1.json
  def destroy
    @in_host_neg.destroy
    respond_to do |format|
      format.html { redirect_to in_host_negs_url, notice: 'In host neg was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_in_host_neg
      @in_host_neg = InHostNeg.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def in_host_neg_params
      params.require(:in_host_neg).permit(:term)
    end
end
