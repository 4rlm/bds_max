class GeoPlacesController < ApplicationController
    before_action :set_geo_place, only: [:show, :edit, :update, :destroy]
    before_action :set_geo_place_service, only: [:geo_places_starter_btn, :geo_power_btn]

    # GET /geo_places
    # GET /geo_places.json
    def index
        @geo_places = GeoPlace.all
    end

    # GET /geo_places/1
    # GET /geo_places/1.json
    def show
    end

    # GET /geo_places/new
    def new
        @geo_place = GeoPlace.new
    end

    # GET /geo_places/1/edit
    def edit
    end

    # POST /geo_places
    # POST /geo_places.json
    def create
        @geo_place = GeoPlace.new(geo_place_params)

        respond_to do |format|
            if @geo_place.save
                format.html { redirect_to @geo_place, notice: 'Geo place was successfully created.' }
                format.json { render :show, status: :created, location: @geo_place }
            else
                format.html { render :new }
                format.json { render json: @geo_place.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /geo_places/1
    # PATCH/PUT /geo_places/1.json
    def update
        respond_to do |format|
            if @geo_place.update(geo_place_params)
                format.html { redirect_to @geo_place, notice: 'Geo place was successfully updated.' }
                format.json { render :show, status: :ok, location: @geo_place }
            else
                format.html { render :edit }
                format.json { render json: @geo_place.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /geo_places/1
    # DELETE /geo_places/1.json
    def destroy
        @geo_place.destroy
        respond_to do |format|
            format.html { redirect_to geo_places_url, notice: 'Geo place was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    def geo_power_btn
        @service.street_cleaner
        redirect_to geo_places_path
    end


    def geo_places_starter_btn
        @service.geo_places_starter
        redirect_to geo_places_path
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_geo_place
        @geo_place = GeoPlace.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def geo_place_params
        params.require(:geo_place).permit(:sfdc_id, :account, :street, :city, :state, :zip, :latitude, :longitude, :phone, :website, :map_url, :img_url, :hierarchy, :place_id, :address_components, :reference, :aspects, :reviews)
    end

    def set_geo_place_service
        @service = GeoPlaceService.new
    end
end
