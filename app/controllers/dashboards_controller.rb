class DashboardsController < ApplicationController
    before_action :intermediate_and_up, only: [:index, :show]
    before_action :admin_only, only: [:new, :create, :edit, :update, :destroy]
    # before_action :set_dashboard, only: [:show, :edit, :update, :destroy]
    # before_action :set_dashboard, only: [:show, :edit, :update, :destroy, :import_page, :import_csv_data]
    before_action :set_dashboard_service, only: [:dashboard_mega_btn, :cores_dash_btn, :whos_dash_btn, :delayed_jobs_dash_btn, :franchise_dash_btn, :indexer_dash_btn, :geo_locations_dash_btn, :staffers_dash_btn, :users_dash_btn, :whos_dash_btn, :import_page, :import_csv_data]
    # before_action :set_dashboard, only: [:import_page, :import_csv_data]

    # GET /dashboards
    # GET /dashboards.json
    def index
        @dashboards = Dashboard.all

        # CSV #
        dashboards_csv = @dashboards.order(:updated_at)
        respond_to do |format|
            format.html
            format.csv { render text: dashboards_csv.to_csv }
        end


        # # Core All
        # @core_all = Core.count
    end

    # GET /dashboards/1
    # GET /dashboards/1.json
    def show
    end

    # GET /dashboards/new
    def new
        @dashboard = Dashboard.new
    end

    def import_page
    end

    def import_csv_data
        file_name = params[:file]
        Dashboard.import_csv(file_name)

        flash[:notice] = "CSV imported successfully."
        redirect_to dashboards_path
    end


    # GET /dashboards/1/edit
    def edit
    end

    # POST /dashboards
    # POST /dashboards.json
    def create
        @dashboard = Dashboard.new(dashboard_params)

        respond_to do |format|
            if @dashboard.save
                format.html { redirect_to @dashboard, notice: 'Dashboard was successfully created.' }
                format.json { render :show, status: :created, location: @dashboard }
            else
                format.html { render :new }
                format.json { render json: @dashboard.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /dashboards/1
    # PATCH/PUT /dashboards/1.json
    def update
        respond_to do |format|
            if @dashboard.update(dashboard_params)
                format.html { redirect_to @dashboard, notice: 'Dashboard was successfully updated.' }
                format.json { render :show, status: :ok, location: @dashboard }
            else
                format.html { render :edit }
                format.json { render json: @dashboard.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /dashboards/1
    # DELETE /dashboards/1.json
    def destroy
        @dashboard.destroy
        respond_to do |format|
            format.html { redirect_to dashboards_url, notice: 'Dashboard was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    ############ BUTTONS ~ START ##############
    def dashboard_mega_btn
        @service.mega_dash
        # @service.delay.mega_dash
        redirect_to dashboards_path
    end

    def cores_dash_btn
        @service.dash(Core)
        @service.list_getter(Core, [:bds_status, :staff_indexer_status, :location_indexer_status, :staffer_status, :geo_status, :who_status])
        redirect_to dashboards_path
    end

    def franchise_dash_btn
        @service.dash(InHostPo)
        @service.list_getter(InHostPo, [:consolidated_term, :category])
        redirect_to dashboards_path
    end

    def indexer_dash_btn
        @service.dash(Indexer)
        @service.list_getter(Indexer, [:redirect_status, :indexer_status, :who_status, :rt_sts, :cont_sts, :loc_status, :stf_status, :contact_status])
        redirect_to dashboards_path
    end

    def geo_locations_dash_btn
        @service.dash(Location)
        @service.list_getter(Location, [:location_status, :sts_geo_crm, :sts_url, :sts_root, :sts_acct, :sts_addr, :sts_ph, :sts_duplicate, :url_sts, :acct_sts, :addr_sts, :ph_sts])
        redirect_to dashboards_path
    end

    def staffers_dash_btn
        @service.dash(Staffer)
        @service.list_getter(Staffer, [:staffer_status, :cont_status])
        redirect_to dashboards_path
    end

    def whos_dash_btn
        @service.dash(Who)
        @service.list_getter(Who, [:who_status, :url_status])
        redirect_to dashboards_path
    end

    # def delayed_jobs_dash_btn
    ### PROBLEM.  NOT RUNNING.
    #     @service.delayed_jobs_dash
    #     # @service.delay.delayed_jobs_dash
    #
    #     redirect_to dashboards_path
    # end
    ############ BUTTONS ~ END ##############


    private
    # Use callbacks to share common setup or constraints between actions.
    def set_dashboard
        @dashboard = Dashboard.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dashboard_params
        params.fetch(:dashboard, {})
    end

    def set_dashboard_service
        @service = DashboardService.new
    end

end
