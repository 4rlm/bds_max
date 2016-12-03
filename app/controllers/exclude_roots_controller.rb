class ExcludeRootsController < ApplicationController
  before_action :set_exclude_root, only: [:show, :edit, :update, :destroy]

  # GET /exclude_roots
  # GET /exclude_roots.json
  def index
    @exclude_roots = ExcludeRoot.all

    #==== For multi check box
    selects = params[:multi_checks]
    unless selects.nil?
        ExcludeRoot.where(id: selects).destroy_all
    end
    #================
  end

  # GET /exclude_roots/1
  # GET /exclude_roots/1.json
  def show
  end

  # GET /exclude_roots/new
  def new
    @exclude_root = ExcludeRoot.new
  end

  # GET /exclude_roots/1/edit
  def edit
  end

  # POST /exclude_roots
  # POST /exclude_roots.json
  def create
    @exclude_root = ExcludeRoot.new(exclude_root_params)

    respond_to do |format|
      if @exclude_root.save
        format.html { redirect_to @exclude_root, notice: 'Exclude root was successfully created.' }
        format.json { render :show, status: :created, location: @exclude_root }
      else
        format.html { render :new }
        format.json { render json: @exclude_root.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exclude_roots/1
  # PATCH/PUT /exclude_roots/1.json
  def update
    respond_to do |format|
      if @exclude_root.update(exclude_root_params)
        format.html { redirect_to @exclude_root, notice: 'Exclude root was successfully updated.' }
        format.json { render :show, status: :ok, location: @exclude_root }
      else
        format.html { render :edit }
        format.json { render json: @exclude_root.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exclude_roots/1
  # DELETE /exclude_roots/1.json
  def destroy
    @exclude_root.destroy
    respond_to do |format|
      format.html { redirect_to exclude_roots_url, notice: 'Exclude root was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exclude_root
      @exclude_root = ExcludeRoot.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exclude_root_params
      params.require(:exclude_root).permit(:term)
    end
end
