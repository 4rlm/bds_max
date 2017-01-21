class LocationsController < ApplicationController
    before_action :set_location, only: [:show, :edit, :update, :destroy]

    # GET /locations
    # GET /locations.json
    def index

        # MULTI-SELECT #
        if choice_hash = get_selected_status_location
            clean_choice_hash = {}
            @view_mode = choice_hash[:view_mode]

            choice_hash.each do |key, value|
                clean_choice_hash[key] = value if !value.nil? && value != "" && key != :view_mode
            end
            @locations = Location.where(clean_choice_hash).all
        else # choice_hash is nil
            @locations = Location.all
        end

        ## SET ORDER OF DISPLAYED DATA ##
        @locations = @locations.order(updated_at: :desc)

        @locations_count = Location.count
        @selected_locations_count = @locations.count


        # CSV #
        locations_csv = @locations.order(:longitude)
        respond_to do |format|
            format.html
            format.csv { render text: locations_csv.to_csv }
        end

        # WILL_PAGINATE #
        @locations = @locations.filter(filtering_params(params)).paginate(:page => params[:page], :per_page => 150)


        ## GEOCODER SEARCH NEARBY - STARTS##
        # if params[:search].present?
        #     #   @locations = Location.near(params[:search], 50, :order => :distance)
        #     @locations = Location.near(params[:search], 50)
        # else
        #     @locations = Location.all
        # end
        ## GEOCODER SEARCH NEARBY - ENDS##

        # CHECKBOX #
        batch_status
    end

    # GET /locations/1
    # GET /locations/1.json
    def show
    end

    # GET /locations/new
    def new
        @location = Location.new
    end

    # GET /locations/1/edit
    def edit
    end

    def import_page
    end

    def import_csv_data
        file_name = params[:file]
        Location.import_csv(file_name)

        flash[:notice] = "CSV imported successfully."
        redirect_to locations_path
    end

    # POST /locations
    # POST /locations.json
    def create
        @location = Location.new(location_params)

        respond_to do |format|
            if @location.save
                format.html { redirect_to @location, notice: 'Location was successfully created.' }
                format.json { render :show, status: :created, location: @location }
            else
                format.html { render :new }
                format.json { render json: @location.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /locations/1
    # PATCH/PUT /locations/1.json
    def update
        respond_to do |format|
            if @location.update(location_params)
                format.html { redirect_to @location, notice: 'Location was successfully updated.' }
                format.json { render :show, status: :ok, location: @location }
            else
                format.html { render :edit }
                format.json { render json: @location.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /locations/1
    # DELETE /locations/1.json
    def destroy
        @location.destroy
        respond_to do |format|
            format.html { redirect_to locations_url, notice: 'Location was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    def location_migrator
        # cores = Core.all
        cores = Core.all[46383...46388]

        for core in cores
            LocationService.new.delay.create_sfdc_loc(core)
            LocationService.new.delay.create_site_loc(core)
        end

        redirect_to locations_path
    end


    private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
        @location = Location.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
        params.require(:location).permit(:latitude, :longitude, :created_at, :updated_at, :city, :state, :state_code, :postal_code, :coordinates, :acct_name, :group_name, :ult_group_name, :source, :sfdc_id, :tier, :sales_person, :acct_type, :location_status, :rev_full_address, :rev_street, :rev_city, :rev_state, :rev_state_code, :rev_postal_code, :url, :root, :franchise, :street, :address)
    end

    def filtering_params(params)
        params.slice(:latitude, :longitude, :created_at, :updated_at, :city, :state, :state_code, :postal_code, :coordinates, :acct_name, :group_name, :ult_group_name, :source, :sfdc_id, :tier, :sales_person, :acct_type, :location_status, :rev_full_address, :rev_street, :rev_city, :rev_state, :rev_state_code, :rev_postal_code, :url, :root, :franchise, :street, :address)
    end

    def batch_status
        ids = params[:multi_checks]
        return if ids.nil?
        status = params[:selected_status]
        for id in ids
            location = Location.find(id)
            location.update_attribute(:location_status, status)
            flash[:notice] = "Successfully updated"
        end

        destroy_rows(ids) if status == "Destroy"
    end

    def destroy_rows(ids)
        rows = Location.where(id: ids)
        rows.destroy_all
    end

end
