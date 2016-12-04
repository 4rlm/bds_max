class SolitariesController < ApplicationController
  before_action :set_solitary, only: [:show, :edit, :update, :destroy]

  # GET /solitaries
  # GET /solitaries.json
  def index
    # @solitaries = Solitary.all

    @solitaries = Solitary.order(:solitary_root)
    respond_to do |format|
          format.html
          format.csv { render text: @solitaries.to_csv }
      end

    #==== For multi check box
    selects = params[:multi_checks]
    unless selects.nil?
        Solitary.where(id: selects).destroy_all
    end
    #================

  end

  # GET /solitaries/1
  # GET /solitaries/1.json
  def show
  end

  # GET /solitaries/new
  def new
    @solitary = Solitary.new
  end

    # Go to the CSV importing page
    def import_page
    end

    def import_csv_data
      file_name = params[:file]
      Solitary.import_csv(file_name)

      flash[:notice] = "CSV imported successfully."
      redirect_to solitaries_path
    end

  # GET /solitaries/1/edit
  def edit
  end

  # POST /solitaries
  # POST /solitaries.json
  def create
    @solitary = Solitary.new(solitary_params)

    respond_to do |format|
      if @solitary.save
        format.html { redirect_to @solitary, notice: 'Solitary was successfully created.' }
        format.json { render :show, status: :created, location: @solitary }
      else
        format.html { render :new }
        format.json { render json: @solitary.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /solitaries/1
  # PATCH/PUT /solitaries/1.json
  def update
    respond_to do |format|
      if @solitary.update(solitary_params)
        format.html { redirect_to @solitary, notice: 'Solitary was successfully updated.' }
        format.json { render :show, status: :ok, location: @solitary }
      else
        format.html { render :edit }
        format.json { render json: @solitary.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /solitaries/1
  # DELETE /solitaries/1.json
  def destroy
    @solitary.destroy
    respond_to do |format|
      format.html { redirect_to solitaries_url, notice: 'Solitary was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_solitary
      @solitary = Solitary.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def solitary_params
      params.require(:solitary).permit(:solitary_root, :solitary_url)
    end
end
