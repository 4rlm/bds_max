class WhosController < ApplicationController
  before_action :set_who, only: [:show, :edit, :update, :destroy]

  # GET /whos
  # GET /whos.json
  def index
    @whos = Who.all
  end

  # GET /whos/1
  # GET /whos/1.json
  def show
  end

  # GET /whos/new
  def new
    @who = Who.new
  end

  # GET /whos/1/edit
  def edit
  end

  # POST /whos
  # POST /whos.json
  def create
    @who = Who.new(who_params)

    respond_to do |format|
      if @who.save
        format.html { redirect_to @who, notice: 'Who was successfully created.' }
        format.json { render :show, status: :created, location: @who }
      else
        format.html { render :new }
        format.json { render json: @who.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /whos/1
  # PATCH/PUT /whos/1.json
  def update
    respond_to do |format|
      if @who.update(who_params)
        format.html { redirect_to @who, notice: 'Who was successfully updated.' }
        format.json { render :show, status: :ok, location: @who }
      else
        format.html { render :edit }
        format.json { render json: @who.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /whos/1
  # DELETE /whos/1.json
  def destroy
    @who.destroy
    respond_to do |format|
      format.html { redirect_to whos_url, notice: 'Who was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_who
      @who = Who.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def who_params
      params.require(:who).permit(:domain, :domain_id, :ip, :server1, :server2, :registrar_url, :registrar_id, :registrant_id, :registrant_type, :registrant_name, :registrant_organization, :registrant_address, :registrant_city, :registrant_zip, :registrant_state, :registrant_country, :registrant_country_code, :registrant_phone, :registrant_fax, :registrant_email, :registrant_url, :registrant_created_on, :registrant_updated_on, :admin_id, :admin_type, :admin_name, :admin_organization, :admin_address, :admin_city, :admin_zip, :admin_state, :admin_country, :admin_country_code, :admin_phone, :admin_fax, :admin_email, :admin_url, :admin_created_on, :admin_updated_on, :tech_id, :tech_type, :tech_name, :tech_organization, :tech_address, :tech_city, :tech_zip, :tech_state, :tech_country, :tech_country_code, :tech_phone, :tech_fax, :tech_email, :tech_url, :tech_created_on, :tech_updated_on)
    end
end
