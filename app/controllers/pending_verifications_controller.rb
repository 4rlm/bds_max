class PendingVerificationsController < ApplicationController
    before_action :set_pending_verification, only: [:show, :edit, :update, :destroy]

    # GET /pending_verifications
    # GET /pending_verifications.json
    def index


        @pending_verifications_count = PendingVerification.count
        #   @selected_pending_verifications_count = @selected_data.count



        @pending_verifications = PendingVerification.order(:root)
        respond_to do |format|
            format.html
            format.csv { render text: @pending_verifications.to_csv }
        end

        #==== For multi check box
        selects = params[:multi_checks]
        unless selects.nil?
            PendingVerification.where(id: selects).destroy_all
        end
        #================

    end

    # GET /pending_verifications/1
    # GET /pending_verifications/1.json
    def show
    end

    # GET /pending_verifications/new
    def new
        @pending_verification = PendingVerification.new
    end

    # Go to the CSV importing page
    def import_page
    end

    def import_csv_data
        file_name = params[:file]
        PendingVerification.import_csv(file_name)

        flash[:notice] = "CSV imported successfully."
        redirect_to pending_verifications_path
    end

    # GET /pending_verifications/1/edit
    def edit
    end

    # POST /pending_verifications
    # POST /pending_verifications.json
    def create
        @pending_verification = PendingVerification.new(pending_verification_params)

        respond_to do |format|
            if @pending_verification.save
                format.html { redirect_to @pending_verification, notice: 'Pending verification was successfully created.' }
                format.json { render :show, status: :created, location: @pending_verification }
            else
                format.html { render :new }
                format.json { render json: @pending_verification.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /pending_verifications/1
    # PATCH/PUT /pending_verifications/1.json
    def update
        respond_to do |format|
            if @pending_verification.update(pending_verification_params)
                format.html { redirect_to @pending_verification, notice: 'Pending verification was successfully updated.' }
                format.json { render :show, status: :ok, location: @pending_verification }
            else
                format.html { render :edit }
                format.json { render json: @pending_verification.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /pending_verifications/1
    # DELETE /pending_verifications/1.json
    def destroy
        @pending_verification.destroy
        respond_to do |format|
            format.html { redirect_to pending_verifications_url, notice: 'Pending verification was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_pending_verification
        @pending_verification = PendingVerification.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pending_verification_params
        params.require(:pending_verification).permit(:root, :domain)
    end
end
