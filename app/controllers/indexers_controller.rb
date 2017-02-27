class IndexersController < ApplicationController
  before_action :set_indexer, only: [:show, :edit, :update, :destroy]

  before_action :set_indexer_service, only: [:indexer_starter_btn, :reset_errors_btn, :indexer_power_btn, :template_finder_btn, :rooftop_data_getter_btn]


  # GET /indexers
  # GET /indexers.json
  def index
    @indexers = Indexer.all

    ## SET ORDER OF DISPLAYED DATA ##
    @indexers = @indexers.order(updated_at: :desc)

    # CSV #
    indexers_csv = @indexers.order(:clean_url)
    respond_to do |format|
        format.html
        format.csv { render text: indexers_csv.to_csv }
    end


    #---------  Adam's Trial - Starts --- WORKS WELL!
    # @indexers = @indexers.filter(filtering_params(params)).paginate(:page => params[:page], :per_page => 50)

    @indexers = @indexers.paginate(:page => params[:page], :per_page => 100)
    #---------  Adam's Trial - Ends -------

    batch_status
  end

  # GET /indexers/1
  # GET /indexers/1.json
  def show
  end

  # GET /indexers/new
  def new
    @indexer = Indexer.new
  end

  def import_page
  end

  def import_csv_data
      file_name = params[:file]
      Indexer.import_csv(file_name)

      flash[:notice] = "CSV imported successfully."
      redirect_to indexers_path
  end


  # GET /indexers/1/edit
  def edit
  end


  # POST /indexers
  # POST /indexers.json
  def create
    @indexer = Indexer.new(indexer_params)

    respond_to do |format|
      if @indexer.save
        format.html { redirect_to @indexer, notice: 'Indexer was successfully created.' }
        format.json { render :show, status: :created, location: @indexer }
      else
        format.html { render :new }
        format.json { render json: @indexer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /indexers/1
  # PATCH/PUT /indexers/1.json
  def update
    respond_to do |format|
      if @indexer.update(indexer_params)
        format.html { redirect_to @indexer, notice: 'Indexer was successfully updated.' }
        format.json { render :show, status: :ok, location: @indexer }
      else
        format.html { render :edit }
        format.json { render json: @indexer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /indexers/1
  # DELETE /indexers/1.json
  def destroy
    @indexer.destroy
    respond_to do |format|
      format.html { redirect_to indexers_url, notice: 'Indexer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end




  ### =============== BUTTONS Start ===============

  def indexer_power_btn
    # @service.url_arr_extractor
    # @service.url_redirect_checker
    # @service.scraped_contacts_sts_checker
    # @service.count_contacts
    # @service.dup_url_cleaner
    # @service.delay.dup_url_cleaner
    # @service.staff_url_cleaner
    # @service.pending_verifications_importer
    # @service.delay.pending_verifications_importer
    # @service.url_downcase
    # @service.delay.url_downcase
    # @service.hyrell_cleaner
    # @service.url_redirect_checker
    #   @service.delay.url_redirect_checker

    # @service.template_counter


      redirect_to indexers_path
  end


  def reset_errors_btn
        @service.reset_errors

      redirect_to indexers_path
  end


  def indexer_starter_btn
    #   @service.indexer_starter
        @service.delay.indexer_starter
    #   @service.url_importer

      redirect_to indexers_path
  end

  def template_finder_btn
    #   @service.template_finder
      @service.delay.template_finder


      redirect_to indexers_path
  end


  def rooftop_data_getter_btn
      @service.rooftop_data_getter
    #   @service.delay.rooftop_data_getter

      redirect_to indexers_path
  end





  ### =============== BUTTONS End ===============




  private
    # Use callbacks to share common setup or constraints between actions.
    def set_indexer
      @indexer = Indexer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def indexer_params
      params.require(:indexer).permit(:raw_url, :redirect_status, :clean_url, :indexer_status, :staff_url, :staff_text, :location_url, :location_text, :template, :crm_id_arr, :loc_status, :stf_status)
    end


    def filtering_params(params)
        params.slice(:raw_url, :redirect_status, :clean_url, :indexer_status, :staff_url, :staff_text, :location_url, :location_text, :template, :loc_status, :stf_status)
    end


    def set_indexer_service
        @service = IndexerService.new
    end


    def batch_status
        ids = params[:multi_checks]
        return if ids.nil?
        status = params[:selected_status]
        for id in ids
            indexer = Indexer.find(id)
            indexer.update_attribute(:indexer_status, status)
            flash[:notice] = "Successfully updated"

            # core = Core.find_by(sfdc_id: indexer.sfdc_id)
            # core.update_attribute(:location_indexer_status, status)
        end

        destroy_rows(ids) if status == "Destroy"
    end

    def destroy_rows(ids)
        rows = Indexer.where(id: ids)
        rows.destroy_all
    end







end