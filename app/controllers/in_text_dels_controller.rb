class InTextDelsController < ApplicationController
  before_action :set_in_text_del, only: [:show, :edit, :update, :destroy]

  # GET /in_text_dels
  # GET /in_text_dels.json
  def index
    @in_text_dels = InTextDel.all
  end

  # GET /in_text_dels/1
  # GET /in_text_dels/1.json
  def show
  end

  # GET /in_text_dels/new
  def new
    @in_text_del = InTextDel.new
  end

  # GET /in_text_dels/1/edit
  def edit
  end

  # POST /in_text_dels
  # POST /in_text_dels.json
  def create
    @in_text_del = InTextDel.new(in_text_del_params)

    respond_to do |format|
      if @in_text_del.save
        format.html { redirect_to @in_text_del, notice: 'In text del was successfully created.' }
        format.json { render :show, status: :created, location: @in_text_del }
      else
        format.html { render :new }
        format.json { render json: @in_text_del.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /in_text_dels/1
  # PATCH/PUT /in_text_dels/1.json
  def update
    respond_to do |format|
      if @in_text_del.update(in_text_del_params)
        format.html { redirect_to @in_text_del, notice: 'In text del was successfully updated.' }
        format.json { render :show, status: :ok, location: @in_text_del }
      else
        format.html { render :edit }
        format.json { render json: @in_text_del.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /in_text_dels/1
  # DELETE /in_text_dels/1.json
  def destroy
    @in_text_del.destroy
    respond_to do |format|
      format.html { redirect_to in_text_dels_url, notice: 'In text del was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_in_text_del
      @in_text_del = InTextDel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def in_text_del_params
      params.require(:in_text_del).permit(:term)
    end
end
