class InSuffixDelsController < ApplicationController
  before_action :set_in_suffix_del, only: [:show, :edit, :update, :destroy]

  # GET /in_suffix_dels
  # GET /in_suffix_dels.json
  def index
    # @in_suffix_dels = InSuffixDel.all

    @in_suffix_dels = InSuffixDel.order(:term)
    respond_to do |format|
          format.html
          format.csv { render text: @in_suffix_dels.to_csv }
      end

    #==== For multi check box
    selects = params[:multi_checks]
    unless selects.nil?
        InSuffixDel.where(id: selects).destroy_all
    end
    #================

  end

  # GET /in_suffix_dels/1
  # GET /in_suffix_dels/1.json
  def show
  end

  # GET /in_suffix_dels/new
  def new
    @in_suffix_del = InSuffixDel.new
  end

    # Go to the CSV importing page
    def import_page
    end

    def import_csv_data
      file_name = params[:file]
      InSuffixDel.import_csv(file_name)

      flash[:notice] = "CSV imported successfully."
      redirect_to in_suffix_dels_path
    end


  # GET /in_suffix_dels/1/edit
  def edit
  end

  # POST /in_suffix_dels
  # POST /in_suffix_dels.json
  def create
    @in_suffix_del = InSuffixDel.new(in_suffix_del_params)

    respond_to do |format|
      if @in_suffix_del.save
        format.html { redirect_to @in_suffix_del, notice: 'In suffix del was successfully created.' }
        format.json { render :show, status: :created, location: @in_suffix_del }
      else
        format.html { render :new }
        format.json { render json: @in_suffix_del.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /in_suffix_dels/1
  # PATCH/PUT /in_suffix_dels/1.json
  def update
    respond_to do |format|
      if @in_suffix_del.update(in_suffix_del_params)
        format.html { redirect_to @in_suffix_del, notice: 'In suffix del was successfully updated.' }
        format.json { render :show, status: :ok, location: @in_suffix_del }
      else
        format.html { render :edit }
        format.json { render json: @in_suffix_del.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /in_suffix_dels/1
  # DELETE /in_suffix_dels/1.json
  def destroy
    @in_suffix_del.destroy
    respond_to do |format|
      format.html { redirect_to in_suffix_dels_url, notice: 'In suffix del was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_in_suffix_del
      @in_suffix_del = InSuffixDel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def in_suffix_del_params
      params.require(:in_suffix_del).permit(:term)
    end
end
