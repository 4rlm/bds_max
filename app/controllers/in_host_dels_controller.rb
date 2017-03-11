class InHostDelsController < ApplicationController
    before_action :set_in_host_del, only: [:show, :edit, :update, :destroy]

    # GET /in_host_dels
    # GET /in_host_dels.json
    def index
        # @in_host_dels = InHostDel.all

        @in_host_dels = InHostDel.order(:term)
        respond_to do |format|
            format.html
            format.csv { render text: @in_host_dels.to_csv }
        end

        #==== For multi check box
        selects = params[:multi_checks]
        unless selects.nil?
            InHostDel.where(id: selects).destroy_all
        end
        #================

    end

    # GET /in_host_dels/1
    # GET /in_host_dels/1.json
    def show
    end

    # GET /in_host_dels/new
    def new
        @in_host_del = InHostDel.new
    end

    # Go to the CSV importing page
    def import_page
    end

    def import_csv_data
        file_name = params[:file]
        InHostDel.import_csv(file_name)

        flash[:notice] = "CSV imported successfully."
        redirect_to in_host_dels_path
    end

    # GET /in_host_dels/1/edit
    def edit
    end

    # POST /in_host_dels
    # POST /in_host_dels.json
    def create
        @in_host_del = InHostDel.new(in_host_del_params)

        respond_to do |format|
            if @in_host_del.save
                format.html { redirect_to @in_host_del, notice: 'In host del was successfully created.' }
                format.json { render :show, status: :created, location: @in_host_del }
            else
                format.html { render :new }
                format.json { render json: @in_host_del.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /in_host_dels/1
    # PATCH/PUT /in_host_dels/1.json
    def update
        respond_to do |format|
            if @in_host_del.update(in_host_del_params)
                format.html { redirect_to @in_host_del, notice: 'In host del was successfully updated.' }
                format.json { render :show, status: :ok, location: @in_host_del }
            else
                format.html { render :edit }
                format.json { render json: @in_host_del.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /in_host_dels/1
    # DELETE /in_host_dels/1.json
    def destroy
        @in_host_del.destroy
        respond_to do |format|
            format.html { redirect_to in_host_dels_url, notice: 'In host del was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_in_host_del
        @in_host_del = InHostDel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def in_host_del_params
        params.require(:in_host_del).permit(:term)
    end
end
