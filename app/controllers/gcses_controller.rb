class GcsesController < ApplicationController
    before_action :set_gcse, only: [:show, :edit, :update, :destroy]
    before_action :set_gcse_service, only: [:gcse_cleaner_btn, :index, :auto_match_btn]

    # GET /gcses
    # GET /gcses.json
    def index
        if choice_hash = get_selected_status_gcse
            clean_choice_hash = {}
            choice_hash.each do |key, value|
                clean_choice_hash[key] = value if !value.nil? && value != ""
            end
            @selected_data = Gcse.where(clean_choice_hash)
        else # choice_hash is nil
            @selected_data = Gcse.all
        end

        @gcses = @selected_data.filter(filtering_params(params)).paginate(:page => params[:page], :per_page => 350)


        @gcses_count = Gcse.count
        @selected_gcses_count = @selected_data.count


        @gcses_csv = @selected_data.order(:sfdc_id)
            respond_to do |format|
              format.html
              format.csv { render text: @gcses_csv.to_csv }
        end

        # Checkbox: multi-selected rows are manipulated in "batch_status".
        batch_status
    end

    # GET /gcses/1
    # GET /gcses/1.json
    def show
    end

    def search
    end

    # GET /gcses/new
    def new
        @gcse = Gcse.new
    end

    def import_page
    end

    def import
      file_name = params[:file]
      Gcse.import_csv(file_name)

      flash[:notice] = "CSV imported successfully."
      redirect_to gcses_path
    end

    # GET /gcses/1/edit
    def edit
    end

    # POST /gcses
    # POST /gcses.json
    def create
        @gcse = Gcse.new(gcse_params)

        respond_to do |format|
            if @gcse.save
                format.html { redirect_to @gcse, notice: 'Gcse was successfully created.' }
                format.json { render :show, status: :created, location: @gcse }
            else
                format.html { render :new }
                format.json { render json: @gcse.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /gcses/1
    # PATCH/PUT /gcses/1.json
    def update
        respond_to do |format|
            if @gcse.update(gcse_params)
                format.html { redirect_to @gcse, notice: 'Gcse was successfully updated.' }
                format.json { render :show, status: :ok, location: @gcse }
            else
                format.html { render :edit }
                format.json { render json: @gcse.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /gcses/1
    # DELETE /gcses/1.json
    def destroy
        @gcse.destroy
        respond_to do |format|
            format.html { redirect_to gcses_url, notice: 'Gcse was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    def gcse_cleaner_btn
        @gcse_service.gcse_cleaner_btn
        flash[:notice] = "Gcse cleaned successfully."
        redirect_to gcses_path
    end

    def auto_match_btn
        # auto_matchify_rows(Gcse.where(domain_status: "Dom Result"))  # Only for "Dom Result"
        # auto_matchify_rows(Gcse.all[0...3000])  # For testing purposes
        auto_matchify_rows(Gcse.all)  # For All Gcse
        flash[:notice] = "Auto Matching successfully completed."
        redirect_to gcses_path
    end

    def quick_dom_dom_res_2
        set_selected_status_gcse({"domain_status"=>["Dom Result"], "gcse_result_num"=>["35"]})
        # set_selected_status_gcse({"gcse_result_num"=>["2"]})
        redirect_to gcses_path
    end

    def quick_dom_no_auto_match_2
        set_selected_status_gcse({"domain_status"=>["No Auto-Matches"], "gcse_result_num"=>["35"]})
        # set_selected_status_gcse({"gcse_result_num"=>["2"]})
        redirect_to gcses_path
    end

    def gcse_unique_rooter
        gcses = Gcse.all
        uniq_roots = []
        gcses.each do |gcse|
            if uniq_roots.include?(gcse.root)
                gcse.destroy
            else
                uniq_roots << gcse.root
            end
        end
        redirect_to gcses_path
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_gcse
        @gcse = Gcse.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gcse_params
        params.require(:gcse).permit(:domain_status, :gcse_timestamp, :gcse_query_num, :gcse_result_num, :sfdc_id, :sfdc_ult_acct, :sfdc_acct, :sfdc_type, :sfdc_street, :sfdc_city, :sfdc_state, :sfdc_url_o, :sfdc_root, :root, :domain, :root_counter, :suffix, :in_host_pos, :exclude_root, :text, :in_text_pos, :in_text_del)
    end

    def filtering_params(params)
        params.slice(:domain_status, :gcse_timestamp, :gcse_query_num, :gcse_result_num, :sfdc_id, :sfdc_ult_acct, :sfdc_acct, :sfdc_type, :sfdc_street, :sfdc_city, :sfdc_state, :sfdc_url_o, :sfdc_root, :root, :domain, :root_counter, :suffix, :in_host_pos, :exclude_root, :text, :in_text_pos, :in_text_del)
    end

    def set_gcse_service
        @gcse_service = GcseService.new
    end


    def auto_matchify_rows(gcses)
        # gcses = Gcse.where(id: ids, gcse_result_num: 2)
        ids = []

        for gcse in gcses
            if @gcse_service.auto_root_acct_match(gcse)
                ids << gcse.id
            else
                gcses = Gcse.where(sfdc_id: gcse.sfdc_id)
                gcses.each {|gcse| gcse.update_attribute(:domain_status, "No Auto-Matches")}
            end
        end
        @gcse_service.matchify_rows(Gcse.where(id: ids))  # Note: matchify_rows method is moved to service.
    end

    def check_core_if_exists?(root, domain)
        cores = Core.all
        root_bool = cores.map(&:sfdc_root).include?(root) || cores.map(&:matched_root).include?(root)
        url_bool = cores.map(&:sfdc_url).include?(domain) || cores.map(&:matched_url).include?(domain)

        if root_bool && url_bool
            return true
        end
        false
    end

    def check_solitary_if_exists?(root, domain)
        result_arr = Solitary.where(solitary_root: root, solitary_url: domain)
        return result_arr.any? ? true : false
    end

    def check_exclude_root_if_exists?(root)
        result_arr = ExcludeRoot.where(term: root)
        return result_arr.any? ? true : false
    end

    def check_if_text_include_pos?(text)
        InTextPo.all.each do |po|
            if text.include?(po.term)
                return true
            end
        end
        false
    end

    def check_if_text_include_del?(text)
        InTextDel.all.each do |del|
            if text.include?(del.term)
                return false
            end
        end
        true
    end

    def batch_status
        ids = params[:status_checks]
        status = params[:selected_status]
        unless ids.nil?
            for id in ids
                data = Gcse.find(id)
                data.update_attribute(:domain_status, status)
            end
            gcses = Gcse.where(id: ids)
            junkify_rows(ids) if status == "Junk"
            destroy_rows(ids) if status == "Destroy"
            @gcse_service.delay.matchify_rows(gcses) if status == "Matched" # Note: matchify_rows method is moved to service.
            @gcse_service.delay.no_matchify_rows(ids) if status == "No Matches"
            auto_matchify_rows(gcses) if status == "Auto-Match"
        end
    end

    # This method deletes the rows which domain_status is "Destroy".
    def destroy_rows(ids)
        rows = Gcse.where(id: ids)
        rows.destroy_all
    end

    # This method deletes the rows which domain_status is "Junk" and adds its new_root to "Junk Roots" table.
    # Simultaneously delete all rows containing junkify root.
    def junkify_rows(ids)
        rows = Gcse.where(id: ids)
        junk_roots_terms = rows.map(&:root)
        rows.destroy_all

        for term in junk_roots_terms
            Gcse.where(root: term).destroy_all  # Delete rest rows which "root" is "term".
            ExcludeRoot.find_or_create_by(term: term)  # Create if not exists.
        end
    end

end
