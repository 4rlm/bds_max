class LocationsController < ApplicationController
    before_action :set_location, only: [:show, :edit, :update, :destroy]
    before_action :set_location_service, only: [:geo_starter_btn, :location_cleaner_btn, :geo_update_migrate_btn, :geo_places_starter_btn, :location_power_btn, :turbo_matcher_btn]

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
        @locations = @locations.filter(filtering_params(params)).paginate(:page => params[:page], :per_page => 30)


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


        # This is a Test for iFrame
        # @url = Location.find(params[:id])

    end

    # GET /locations/1
    # GET /locations/1.json
    def show
        # This is a Test for iFrame
        # @url = Location.find(params[:id])
        @locations = @location.nearbys(1)
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

    # Testing iFrame
    # def open_url
    #   @url = params[:url]
    # end

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

    def turbo_matcher_btn
        # @service.turbo_matcher
        # @service.delay.turbo_matcher
        # @service.delay.web_acct_name_cleaner

        # @service.www_inserter

        # @service.url_redirect_checker
        # @service.delay.url_redirect_checker

        # @service.root_and_url_finalizer
        # @service.delay.root_and_url_finalizer

        # @service.root_matcher

        @service.sts_updater


        redirect_to locations_path
    end


    def location_power_btn
        # @service.street_cleaner
        # @service.white_space_cleaner

        redirect_to locations_path
    end


    def geo_places_starter_btn
        # @service.geo_places_starter
        @service.delay.geo_places_starter

        redirect_to locations_path
    end

    # def geo_starter_btn  ## From Button
    #     # @service.delay.create_sfdc_loc
    #     # @service.create_sfdc_loc
    #     cores = Core.all[0..10]
    #
    #     LocationService.new.start_geo(cores)
    #     # LocationService.new.delay.start_geo(cores)
    #
    #     flash[:notice] = 'Geo started!'
    #     redirect_to locations_path
    # end

    def location_cleaner_btn
        # @service.delay.location_cleaner_btn
        # @service.location_cleaner_btn
        redirect_to root_path
    end

    def geo_update_migrate_btn
        # @service.delay.geo_update_migrate_btn
        # @service.geo_update_migrate_btn

        redirect_to root_path
    end

    def update_status
        location = Location.find(params[:location_id])

        case params[:location_col]
        when "root"
            location.update_attributes(crm_url: location.url, crm_root: location.geo_root)
        when "acct"
            location.update_attribute(:acct_name, location.geo_acct_name)
        when "address"
            location.update_attributes(address: location.geo_full_addr, crm_street: location.street, crm_city: location.city, crm_state: location.state_code, crm_zip: location.postal_code)
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
        @location = Location.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
        params.require(:location).permit(:latitude, :longitude, :created_at, :updated_at, :city, :state, :state_code, :postal_code, :coordinates, :acct_name, :group_name, :ult_group_name, :source, :sfdc_id, :tier, :sales_person, :acct_type, :location_status, :url, :crm_root, :street, :address, :temporary_id, :geo_acct_name, :geo_full_addr, :phone, :map_url, :img_url, :place_id, :crm_source, :geo_root, :crm_root, :crm_url, :geo_franch_term, :geo_franch_cons, :geo_franch_cat, :crm_franch_term, :crm_franch_cons, :crm_franch_cat, :crm_phone, :crm_url_redirect, :geo_url_redirect, :sts_geo_crm, :sts_url, :sts_root, :sts_acct, :sts_addr, :sts_ph, :sts_duplicate)
    end

    def filtering_params(params)
        params.slice(:latitude, :longitude, :created_at, :updated_at, :city, :state, :state_code, :postal_code, :coordinates, :acct_name, :group_name, :ult_group_name, :source, :sfdc_id, :tier, :sales_person, :acct_type, :location_status, :url, :crm_root, :street, :address, :temporary_id, :geo_acct_name, :geo_full_addr, :crm_source, :geo_root, :crm_root, :crm_url, :geo_franch_term, :geo_franch_cons, :geo_franch_cat, :crm_franch_term, :crm_franch_cons, :crm_franch_cat, :crm_phone, :crm_url_redirect, :geo_url_redirect, :sts_geo_crm, :sts_url, :sts_root, :sts_acct, :sts_addr, :sts_ph, :sts_duplicate)
    end


    def set_location_service
        @service = LocationService.new
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
