class DashboardsController < ApplicationController
    before_action :intermediate_and_up, only: [:index, :show]
    before_action :admin_only, only: [:new, :create, :edit, :update, :destroy]
    # before_action :set_dashboard, only: [:show, :edit, :update, :destroy]
    # before_action :set_dashboard, only: [:show, :edit, :update, :destroy, :import_page, :import_csv_data]
    before_action :set_dashboard_service, only: [:dashboard_starter_btn, :cores_dash_btn, :whos_dash_btn, :delayed_jobs_dash_btn, :franchise_dash_btn, :indexer_dash_btn, :geo_locations_dash_btn, :staffers_dash_btn, :users_dash_btn, :whos_dash_btn, :import_page, :import_csv_data]
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
    def dashboard_starter_btn
        @dashboard_service.dash_starter
        # @dashboard_service.delay.dash_starter

        redirect_to dashboards_path
    end

    def cores_dash_btn
        @dashboard_service.cores_dash
        # @dashboard_service.delay.cores_dash

        redirect_to dashboards_path
    end

    def whos_dash_btn
        @dashboard_service.whos_dash
        # @dashboard_service.delay.whos_dash

        redirect_to dashboards_path
    end

    # def delayed_jobs_dash_btn
    ### PROBLEM.  NOT RUNNING.
    #     @dashboard_service.delayed_jobs_dash
    #     # @dashboard_service.delay.delayed_jobs_dash
    #
    #     redirect_to dashboards_path
    # end

    def franchise_dash_btn
        @dashboard_service.franchise_dash
        # @dashboard_service.delay.franchise_dash

        redirect_to dashboards_path
    end

    def indexer_dash_btn
        @dashboard_service.indexer_dash
        # @dashboard_service.delay.indexer_dash

        redirect_to dashboards_path
    end

    def geo_locations_dash_btn
        @dashboard_service.geo_locations_dash
        # @dashboard_service.delay.geo_locations_dash

        redirect_to dashboards_path
    end

    def staffers_dash_btn
        # @dashboard_service.staffers_dash
        # @dashboard_service.delay.staffers_dash
        @dashboard_service.dash(Staffer)
        @dashboard_service.item_list(Staffer, [:staffer_status, :cont_status])
        redirect_to dashboards_path
    end

    def users_dash_btn
        @dashboard_service.users_dash
        # @dashboard_service.delay.users_dash

        redirect_to dashboards_path
    end

    def whos_dash_btn
        # @dashboard_service.whos_dash
        # @dashboard_service.delay.whos_dash

        @dashboard_service.dash(Who)
        @dashboard_service.item_list(Who, [:who_status, :url_status])

        redirect_to dashboards_path
    end


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
        @dashboard_service = DashboardService.new
    end


    # def get_domainer_query_count
    #     counter = 0
    #     Core.all.each do |core|
    #         if core.domainer_date
    #             counter += 1
    #         end
    #     end
    #     counter
    # end

end
