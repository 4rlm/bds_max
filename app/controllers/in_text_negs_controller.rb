class InTextNegsController < ApplicationController
  before_action :set_in_text_neg, only: [:show, :edit, :update, :destroy]

  # GET /in_text_negs
  # GET /in_text_negs.json
  def index
    @in_text_negs = InTextNeg.all
  end

  # GET /in_text_negs/1
  # GET /in_text_negs/1.json
  def show
  end

  # GET /in_text_negs/new
  def new
    @in_text_neg = InTextNeg.new
  end

  # GET /in_text_negs/1/edit
  def edit
  end

  # POST /in_text_negs
  # POST /in_text_negs.json
  def create
    @in_text_neg = InTextNeg.new(in_text_neg_params)

    respond_to do |format|
      if @in_text_neg.save
        format.html { redirect_to @in_text_neg, notice: 'In text neg was successfully created.' }
        format.json { render :show, status: :created, location: @in_text_neg }
      else
        format.html { render :new }
        format.json { render json: @in_text_neg.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /in_text_negs/1
  # PATCH/PUT /in_text_negs/1.json
  def update
    respond_to do |format|
      if @in_text_neg.update(in_text_neg_params)
        format.html { redirect_to @in_text_neg, notice: 'In text neg was successfully updated.' }
        format.json { render :show, status: :ok, location: @in_text_neg }
      else
        format.html { render :edit }
        format.json { render json: @in_text_neg.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /in_text_negs/1
  # DELETE /in_text_negs/1.json
  def destroy
    @in_text_neg.destroy
    respond_to do |format|
      format.html { redirect_to in_text_negs_url, notice: 'In text neg was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_in_text_neg
      @in_text_neg = InTextNeg.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def in_text_neg_params
      params.require(:in_text_neg).permit(:term)
    end
end
