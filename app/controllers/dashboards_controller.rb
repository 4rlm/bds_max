class DashboardsController < ApplicationController
    before_action :intermediate_and_up, only: [:index, :show]
    before_action :advanced_and_up, only: [:edit, :update]
    before_action :admin_only, only: [:new, :create, :destroy]
    before_action :set_dashboard, only: [:show, :edit, :update, :destroy]

    # GET /dashboards
    # GET /dashboards.json
    def index
        @dashboards = Dashboard.all

        # Core All
        @core_all = Core.count
    end

    # GET /dashboards/1
    # GET /dashboards/1.json
    def show
    end

    # GET /dashboards/new
    def new
        @dashboard = Dashboard.new
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

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_dashboard
        @dashboard = Dashboard.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dashboard_params
        params.fetch(:dashboard, {})
    end

    def get_domainer_query_count
        counter = 0
        Core.all.each do |core|
            if core.domainer_date
                counter += 1
            end
        end
        counter
    end

end
