class IndexerLocationsController < ApplicationController
    before_action :set_indexer_location, only: [:show, :edit, :update, :destroy]

    # GET /indexer_locations
    # GET /indexer_locations.json
    def index
        @selected_data = IndexerLocation.all
        # @locations = IndexerLocation.order(:domain)
        @locations = IndexerLocation.order(indexer_timestamp: :desc)
        respond_to do |format|
            format.html
            format.csv { render text: @locations.to_csv }
        end

        # Original !!!
        # @indexer_locations = @locations.filter(filtering_params(params))

        #---------  Adam's Trial - Starts --- WORKS WELL!
        @indexer_locations = @locations.filter(filtering_params(params)).paginate(:page => params[:page], :per_page => 100)
        #---------  Adam's Trial - Ends -------

        batch_status
    end

    # GET /indexer_locations/1
    # GET /indexer_locations/1.json
    def show
    end

    # GET /indexer_locations/new
    def new
        @indexer_location = IndexerLocation.new
    end


    # Go to the CSV importing page
    def import_page
    end

    def import_csv_data
        file_name = params[:file]
        IndexerLocation.import_csv(file_name)

        flash[:notice] = "CSV imported successfully."
        redirect_to indexer_locations_path
    end


    # GET /indexer_locations/1/edit
    def edit
    end

    # POST /indexer_locations
    # POST /indexer_locations.json
    def create
        @indexer_location = IndexerLocation.new(indexer_location_params)

        respond_to do |format|
            if @indexer_location.save
                format.html { redirect_to @indexer_location, notice: 'Indexer location was successfully created.' }
                format.json { render :show, status: :created, location: @indexer_location }
            else
                format.html { render :new }
                format.json { render json: @indexer_location.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /indexer_locations/1
    # PATCH/PUT /indexer_locations/1.json
    def update
        respond_to do |format|
            if @indexer_location.update(indexer_location_params)
                format.html { redirect_to @indexer_location, notice: 'Indexer location was successfully updated.' }
                format.json { render :show, status: :ok, location: @indexer_location }
            else
                format.html { render :edit }
                format.json { render json: @indexer_location.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /indexer_locations/1
    # DELETE /indexer_locations/1.json
    def destroy
        @indexer_location.destroy
        respond_to do |format|
            format.html { redirect_to indexer_locations_url, notice: 'Indexer location was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_indexer_location
        @indexer_location = IndexerLocation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def indexer_location_params
        params.require(:indexer_location).permit(:indexer_status, :sfdc_acct, :sfdc_group_name, :sfdc_ult_acct, :root, :domain, :ip, :text, :href, :loc_link, :msg, :sfdc_street, :sfdc_city, :sfdc_state, :sfdc_type, :sfdc_tier, :sfdc_sales_person, :sfdc_id, :indexer_timestamp)
    end

    def filtering_params(params)
        params.slice(:indexer_status, :sfdc_acct, :sfdc_group, :sfdc_ult_grp, :domain, :text, :href, :link, :sfdc_id, :indexer_timestamp)
    end

    def batch_status
        ids = params[:multi_checks]
        return if ids.nil?
        status = params[:selected_status]
        for id in ids
            location = IndexerLocation.find(id)
            location.update_attribute(:indexer_status, status)
            flash[:notice] = "Successfully updated"

            core = Core.find_by(sfdc_id: location.sfdc_id)
            core.update_attribute(:location_indexer_status, status)
        end

        destroy_rows(ids) if status == "Destroy"
    end

    def destroy_rows(ids)
        rows = IndexerLocation.where(id: ids)
        rows.destroy_all
    end

end
