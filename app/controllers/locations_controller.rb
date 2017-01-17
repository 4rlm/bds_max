class LocationsController < ApplicationController
    before_action :set_location, only: [:show, :edit, :update, :destroy]

    # GET /locations
    # GET /locations.json
    def index
        if params[:search].present?
            #   @locations = Location.near(params[:search], 50, :order => :distance)
            @locations = Location.near(params[:search], 50)
        else
            @locations = Location.all
        end

        ##### CSV Export Testing Starts ######
        locations_csv = @locations.order(:longitude)
        respond_to do |format|
            format.html
            format.csv { render text: locations_csv.to_csv }
        end
        ##### CSV Export Testing Ends ######

        #==== For multi check box
        selects = params[:multi_checks]
        unless selects.nil?
            Location.where(id: selects).destroy_all
        end
        #================

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


    ##### CSV Import Testing Starts ######
    # Go to the CSV importing page
    def import_page
    end

    def import_csv_data
        file_name = params[:file]
        Location.import_csv(file_name)

        flash[:notice] = "CSV imported successfully."
        redirect_to locations_path
    end
    ##### CSV Import Testing Ends ######




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


    #### Goal !!!  -Starts ####
    # STEPS:
    # 1) Change to core.acct_source == "SFDC", core.acct_source == "Matched"

    # 2) Where to put this new method? ----
    # def string_detector(str)
    #     unless str.nil?
    #         return str + ", "
    #     end
    # end

    # 3) Test 1, then 5, then 10, then 100 records.
    # 4) Migrate entire Core into Locations tonight.


    ######
    def location_migrator
        # cores = Core.all
        cores = Core.all[0...10]
        serv = LocationService.new

        for core in cores
            serv.create_sfdc_loc(core)
            serv.create_site_loc(core)
        end

        redirect_to locations_path
    end
#### Goal !!!  -Ends ####

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
        @location = Location.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
        params.require(:location).permit(:latitude, :longitude, :created_at, :updated_at, :address, :city, :state, :state_code, :postal_code, :coordinates, :location_status, :acct_name, :group_name, :ult_group_name, :source, :sfdc_id, :tier, :sales_person, :acct_type, :rev_address, :rev_street, :rev_city, :rev_state, :rev_state_code, :rev_postal_code, :url, :root, :franchise)
    end

end
