class SearchController < ApplicationController
    def index

        # == Google API Starts ==Test ! Starts ===
        if params[:q]
          page = params[:page]
          @results = GoogleCustomSearchApi.search(params[:q], page: page)
        end

        # @results = GoogleCustomSearchApi.search(@test_encoded_search)
        # @results = GoogleCustomSearchApi.search("poker", page: 2)
        # @results.pages == 10
        # @results.current_page == 2
        # @results.next_page == 3
        # @results.previous_page == 1
        # @results = GoogleCustomSearchApi.search_and_return_all_results('grossinger toyota')
        # @results = search_and_return_all_results('grossinger toyota')
        # @results.first.items.size # == 10
        # == Google API Starts ==Test ! Ends ===

        # == Google API Starts ==Perfect! Starts ===
        # if params[:q]
        #   page = params[:page] || 1
        #   @results = GoogleCustomSearchApi.search(params[:q], page: page)
        # end
        # == Google API Starts ==Perfect! Ends ===

        # #========================
        # # Core (Accounts) Instance Variables
        # #========================
        #
        # # Core All
        # @core_all = Core.count
        # #============
        #
        # # Core BDS Status
        # @core_bds_status_imported = Core.where(bds_status: "Imported").count
        # @core_bds_status_queue_domainer = Core.where(bds_status: "Queue Domainer").count
        # @core_bds_status_dom_result = Core.where(bds_status: "Dom Result").count
        # @core_bds_status_matched = Core.where(bds_status: "Matched").count
        # @core_bds_status_no_matches = Core.where(bds_status: "No Matches").count
        # @core_bds_status_queue_indexer = Core.where(bds_status: "Queue Indexer").count
        # @core_bds_status_indexer_result = Core.where(bds_status: "Indexer Result").count
        #
        #
        # #============
        #
        # # Core URL Comparison
        # @urls_updated = Core.where(url_comparison: "Different").count
        # @roots_updated = Core.where(root_comparison: "Different").count
        # #============
        #
        # # Core Salesperson
        # @core_sp_peckler = Core.where(sfdc_sales_person: "Marc Peckler").count
        # @core_sp_rosen = Core.where(sfdc_sales_person: "Ben Rosen").count
        # @core_sp_price = Core.where(sfdc_sales_person: "Jason Price").count
        # @core_sp_thompson = Core.where(sfdc_sales_person: "Sarah Thompson").count
        # @core_sp_huffmeyer = Core.where(sfdc_sales_person: "Justin Hufmeyer").count
        # #============
        #
        # # Core Type
        # @core_type_canceled = Core.where(sfdc_type: "Canceled").count
        # @core_type_current_account = Core.where(sfdc_type: "Current Account").count
        # @core_type_current_sub_account = Core.where(sfdc_type: "Current Sub-account").count
        # @core_type_distribution_partner = Core.where(sfdc_type: "Distribution Partner").count
        # @core_type_do_not_solicit = Core.where(sfdc_type: "Do Not Solicit").count
        # @core_type_failure_to_launch = Core.where(sfdc_type: "Failure To Launch").count
        # @core_type_group_division = Core.where(sfdc_type: "Group Division").count
        # @core_type_group_name = Core.where(sfdc_type: "Group Name").count
        # @core_type_inactive = Core.where(sfdc_type: "Inactive").count
        # @core_type_influencer = Core.where(sfdc_type: "Influencer").count
        # @core_type_max_digital_demo_store = Core.where(sfdc_type: "Max Digital Demo Store").count
        # @core_type_prospect = Core.where(sfdc_type: "Prospect").count
        # @core_type_prospect_sub_account = Core.where(sfdc_type: "Prospect Sub-account").count
        # @core_type_vendor = Core.where(sfdc_type: "Vendor").count
        # #============
        #
        # # Core Sales Tier
        # @core_tier_1 = Core.where(sfdc_tier: "Tier 1").count
        # @core_tier_2 = Core.where(sfdc_tier: "Tier 2").count
        # @core_tier_3 = Core.where(sfdc_tier: "Tier 3").count
        # @core_tier_4 = Core.where(sfdc_tier: "Tier 4").count
        # @core_tier_5 = Core.where(sfdc_tier: "Tier 5").count
        # #============
        #
        # # URL Comparison
        # @core_url_comparison_same = Core.where(url_comparison: "Same").count
        # @core_url_comparison_different = Core.where(url_comparison: "Different").count
        # @core_root_comparison_same = Core.where(root_comparison: "Same").count
        # @core_root_comparison_different = Core.where(root_comparison: "Different").count
        # #============
        #
        # # Count per Franchise Term - sfdc
        # @core_sfdc_franchise = Core.where.not(sfdc_franchise: nil).count
        # @core_sfdc_acura = Core.where("sfdc_franchise LIKE ?", "%Acura%").count
        # @core_sfdc_alfa = Core.where("sfdc_franchise LIKE ?", "%Alfa%").count
        # @core_sfdc_aston = Core.where("sfdc_franchise LIKE ?", "%Aston%").count
        # @core_sfdc_audi = Core.where("sfdc_franchise LIKE ?", "%Audi%").count
        # @core_sfdc_bentley = Core.where("sfdc_franchise LIKE ?", "%Bentley%").count
        # @core_sfdc_benz = Core.where("sfdc_franchise LIKE ?", "%Benz%").count
        # @core_sfdc_bmw = Core.where("sfdc_franchise LIKE ?", "%Bmw%").count
        # @core_sfdc_bugatti = Core.where("sfdc_franchise LIKE ?", "%Bugatti%").count
        # @core_sfdc_buick = Core.where("sfdc_franchise LIKE ?", "%Buick%").count
        # @core_sfdc_cadillac = Core.where("sfdc_franchise LIKE ?", "%Cadillac%").count
        #
        # @core_sfdc_cdjr = Core.where("sfdc_franchise LIKE ?", "%Cdjr%").count
        # @core_sfdc_chev = Core.where("sfdc_franchise LIKE ?", "%Chev%").count
        # @core_sfdc_chevrolet = Core.where("sfdc_franchise LIKE ?", "%Chevrolet%").count
        # @core_sfdc_chevy = Core.where("sfdc_franchise LIKE ?", "%Chevy%").count
        # @core_sfdc_chrysler = Core.where("sfdc_franchise LIKE ?", "%Chrysler%").count
        # @core_sfdc_cjd = Core.where("sfdc_franchise LIKE ?", "%Cjd%").count
        # @core_sfdc_corvette = Core.where("sfdc_franchise LIKE ?", "%Corvette%").count
        # @core_sfdc_daewoo = Core.where("sfdc_franchise LIKE ?", "%Daewoo%").count
        # @core_sfdc_dodge = Core.where("sfdc_franchise LIKE ?", "%Dodge%").count
        # @core_sfdc_ferrari = Core.where("sfdc_franchise LIKE ?", "%Ferrari%").count
        # @core_sfdc_fiat = Core.where("sfdc_franchise LIKE ?", "%Fiat%").count
        # @core_sfdc_ford = Core.where("sfdc_franchise LIKE ?", "%Ford%").count
        # @core_sfdc_gm = Core.where("sfdc_franchise LIKE ?", "%Gm%").count
        # @core_sfdc_gmc = Core.where("sfdc_franchise LIKE ?", "%Gmc%").count
        # @core_sfdc_honda = Core.where("sfdc_franchise LIKE ?", "%Honda%").count
        # @core_sfdc_hummer = Core.where("sfdc_franchise LIKE ?", "%Hummer%").count
        # @core_sfdc_hyundai = Core.where("sfdc_franchise LIKE ?", "%Hyundai%").count
        # @core_sfdc_infiniti = Core.where("sfdc_franchise LIKE ?", "%Infiniti%").count
        # @core_sfdc_isuzu = Core.where("sfdc_franchise LIKE ?", "%Isuzu%").count
        # @core_sfdc_jaguar = Core.where("sfdc_franchise LIKE ?", "%Jaguar%").count
        # @core_sfdc_jeep = Core.where("sfdc_franchise LIKE ?", "%Jeep%").count
        # @core_sfdc_kia = Core.where("sfdc_franchise LIKE ?", "%Kia%").count
        # @core_sfdc_lamborghini = Core.where("sfdc_franchise LIKE ?", "%Lamborghini%").count
        # @core_sfdc_lexus = Core.where("sfdc_franchise LIKE ?", "%Lexus%").count
        # @core_sfdc_lincoln = Core.where("sfdc_franchise LIKE ?", "%Lincoln%").count
        # @core_sfdc_lotus = Core.where("sfdc_franchise LIKE ?", "%Lotus%").count
        # @core_sfdc_maserati = Core.where("sfdc_franchise LIKE ?", "%Maserati%").count
        # @core_sfdc_mazda = Core.where("sfdc_franchise LIKE ?", "%Mazda%").count
        # @core_sfdc_mb = Core.where("sfdc_franchise LIKE ?", "%Mb%").count
        # @core_sfdc_mclaren = Core.where("sfdc_franchise LIKE ?", "%Mclaren%").count
        # @core_sfdc_mercedes = Core.where("sfdc_franchise LIKE ?", "%Mercedes%").count
        # @core_sfdc_mercury = Core.where("sfdc_franchise LIKE ?", "%Mercury%").count
        # @core_sfdc_mini = Core.where("sfdc_franchise LIKE ?", "%Mini%").count
        # @core_sfdc_mitsubishi = Core.where("sfdc_franchise LIKE ?", "%Mitsubishi%").count
        # @core_sfdc_nissan = Core.where("sfdc_franchise LIKE ?", "%Nissan%").count
        # @core_sfdc_oldsmobile = Core.where("sfdc_franchise LIKE ?", "%Oldsmobile%").count
        # @core_sfdc_plymouth = Core.where("sfdc_franchise LIKE ?", "%Plymouth%").count
        # @core_sfdc_pontiac = Core.where("sfdc_franchise LIKE ?", "%Pontiac%").count
        # @core_sfdc_porsche = Core.where("sfdc_franchise LIKE ?", "%Porsche%").count
        # @core_sfdc_ram = Core.where("sfdc_franchise LIKE ?", "%Ram%").count
        # @core_sfdc_range = Core.where("sfdc_franchise LIKE ?", "%Range%").count
        # @core_sfdc_rolls = Core.where("sfdc_franchise LIKE ?", "%Rolls%").count
        # @core_sfdc_rover = Core.where("sfdc_franchise LIKE ?", "%Rover%").count
        # @core_sfdc_royce = Core.where("sfdc_franchise LIKE ?", "%Royce%").count
        # @core_sfdc_saab = Core.where("sfdc_franchise LIKE ?", "%Saab%").count
        # @core_sfdc_saturn = Core.where("sfdc_franchise LIKE ?", "%Saturn%").count
        # @core_sfdc_scion = Core.where("sfdc_franchise LIKE ?", "%Scion%").count
        # @core_sfdc_smart = Core.where("sfdc_franchise LIKE ?", "%Smart%").count
        # @core_sfdc_subaru = Core.where("sfdc_franchise LIKE ?", "%Subaru%").count
        # @core_sfdc_suzuki = Core.where("sfdc_franchise LIKE ?", "%Suzuki%").count
        # @core_sfdc_toyota = Core.where("sfdc_franchise LIKE ?", "%Toyota%").count
        # @core_sfdc_volkswagen = Core.where("sfdc_franchise LIKE ?", "%Volkswagen%").count
        # @core_sfdc_volvo = Core.where("sfdc_franchise LIKE ?", "%Volvo%").count
        # @core_sfdc_vw = Core.where("sfdc_franchise LIKE ?", "%Vw%").count
        #
        #
        # # Count per General Term - sfdc
        # @core_sfdc_auto = Core.where("sfdc_franchise LIKE ?", "%Auto%").count
        # @core_sfdc_autogroup = Core.where("sfdc_franchise LIKE ?", "%Autogroup%").count
        # @core_sfdc_automall = Core.where("sfdc_franchise LIKE ?", "%Automall%").count
        # @core_sfdc_automotive = Core.where("sfdc_franchise LIKE ?", "%Automotive%").count
        # @core_sfdc_autoplex = Core.where("sfdc_franchise LIKE ?", "%Autoplex%").count
        # @core_sfdc_autos = Core.where("sfdc_franchise LIKE ?", "%Autos%").count
        # @core_sfdc_autosales = Core.where("sfdc_franchise LIKE ?", "%Autosales%").count
        # @core_sfdc_cars = Core.where("sfdc_franchise LIKE ?", "%Cars%").count
        # @core_sfdc_dealer = Core.where("sfdc_franchise LIKE ?", "%Dealer%").count
        # @core_sfdc_imports = Core.where("sfdc_franchise LIKE ?", "%Imports%").count
        # @core_sfdc_group = Core.where("sfdc_franchise LIKE ?", "%Group%").count
        # @core_sfdc_highline = Core.where("sfdc_franchise LIKE ?", "%Highline%").count
        # @core_sfdc_motor = Core.where("sfdc_franchise LIKE ?", "%Motor%").count
        # @core_sfdc_motors = Core.where("sfdc_franchise LIKE ?", "%Motors%").count
        # @core_sfdc_superstore = Core.where("sfdc_franchise LIKE ?", "%Superstore%").count
        # @core_sfdc_trucks = Core.where("sfdc_franchise LIKE ?", "%Trucks%").count
        # @core_sfdc_usedcars = Core.where("sfdc_franchise LIKE ?", "%Usedcars%").count
        #
        # # Count per General Term - sfdc
        #
        #
        # #============
        #
        # # Analysis
        # # franchise dealers
        #
        # #========================
        # # Gcse (Domainer) Instance Variables
        # #========================
        #
        # # Gcse All
        # @gcse_all = Gcse.count
        #
        # # Domainer Queries
        # @gcse_query_count = get_domainer_query_count
        # @gcse_domain_status_dom_result = Gcse.where(domain_status: "Dom Result").count
        # @gcse_domain_status_no_auto_matches = Gcse.where(domain_status: "No Auto-Matches").count
        #
        # #========================
        # # Discoveries Instance Variables
        # #========================
        # # Solitary All
        #  @solitary_all = Solitary.count
        #
        # #  Pending Verification All
        # @pending_verification_all = PendingVerification.count
        #
        #  #========================
        #  # IndexerStaffs Instance Variables
        #  #========================
        #  @indexer_staff_all = IndexerStaff.count
        #  @indexer_staff_status_matched = IndexerStaff.where(indexer_status: "Matched").count
        #  @indexer_staff_status_no_matches = IndexerStaff.where(indexer_status: "No Matches").count
        #  @indexer_staff_status_error = IndexerStaff.where(indexer_status: "Error").count
        #  @indexer_staff_status_try_again = IndexerStaff.where(indexer_status: "Try Again").count
        #  @indexer_staff_status_verified = IndexerStaff.where(indexer_status: "Verified").count
        #  @indexer_staff_status_ready = IndexerStaff.where(indexer_status: "Ready").count
        #
        #  #========================
        #  # IndexerLocations Instance Variables
        #  #========================
        #  @indexer_location_all = IndexerLocation.count
        #
        #  @indexer_location_status_matched = IndexerLocation.where(indexer_status: "Matched").count
        #  @indexer_location_status_no_matches = IndexerLocation.where(indexer_status: "No Matches").count
        #  @indexer_location_status_error = IndexerLocation.where(indexer_status: "Error").count
        #  @indexer_location_status_try_again = IndexerLocation.where(indexer_status: "Try Again").count
        #  @indexer_location_status_verified = IndexerLocation.where(indexer_status: "Verified").count
        #  @indexer_location_status_ready = IndexerLocation.where(indexer_status: "Ready").count
        #
        #  #========================
        #  # Staffers (Contacts) Instance Variables
        #  #========================
        #  @staffer_all = Staffer.count
        #
        # #  staffer_status
        #

    end

    def dashboard
    end

    def search_result_core
        set_selected_status_core({bds_status: params[:bds_status], sfdc_id: params[:sfdc_id], sfdc_tier: params[:sfdc_tier], sfdc_sales_person: params[:sfdc_sales_person], sfdc_type: params[:sfdc_type], sfdc_ult_grp: params[:sfdc_ult_grp], sfdc_ult_rt: params[:sfdc_ult_rt], sfdc_group: params[:sfdc_group], sfdc_grp_rt: params[:sfdc_grp_rt], sfdc_acct: params[:sfdc_acct], sfdc_street: params[:sfdc_street], sfdc_city: params[:sfdc_city], sfdc_state: params[:sfdc_state], sfdc_zip: params[:sfdc_zip], sfdc_ph: params[:sfdc_ph], sfdc_url: params[:sfdc_url], created_at: params[:created_at], updated_at: params[:updated_at], core_date: params[:core_date], domainer_date: params[:domainer_date], indexer_date: params[:indexer_date], staffer_date: params[:staffer_date], sfdc_root: params[:sfdc_root], staff_indexer_status: params[:staff_indexer_status], location_indexer_status: params[:location_indexer_status], domain_status: params[:domain_status], staffer_status: params[:staffer_status], sfdc_franch_cat: params[:sfdc_franch_cat], acct_source: params[:acct_source], full_address: params[:full_address], geo_status: params[:geo_status], geo_date: params[:geo_date], coordinates: params[:coordinates], sfdc_franch_cons: params[:sfdc_franch_cons], sfdc_template: params[:sfdc_template], url_status: params[:url_status], hierarchy: params[:hierarchy], view_mode: params[:view_mode], geo_address: params[:geo_address], geo_acct: params[:geo_acct]})
        redirect_to cores_path
    end

    def search_result_gcse
        set_selected_status_gcse({domain_status: params[:domain_status], gcse_result_num: params[:gcse_result_num], gcse_timestamp: params[:gcse_timestamp], sfdc_ult_acct: params[:sfdc_ult_acct], sfdc_acct: params[:sfdc_acct], sfdc_type: params[:sfdc_type], sfdc_city: params[:sfdc_city], sfdc_state: params[:sfdc_state], sfdc_id: params[:sfdc_id], sfdc_url_o: params[:sfdc_url_o], domain: params[:domain], root: params[:root], sfdc_root: params[:sfdc_root]})
        redirect_to gcses_path
    end

    def search_result_staffer
        set_selected_status_staffer({staffer_status: params[:staffer_status], cont_status: params[:cont_status], cont_source: params[:cont_source], sfdc_id: params[:sfdc_id], sfdc_sales_person: params[:sfdc_sales_person], sfdc_type: params[:sfdc_type], sfdc_cont_id: params[:sfdc_cont_id], template: params[:template], staffer_date: params[:staffer_date], staff_link: params[:staff_link], staff_text: params[:staff_text], sfdc_cont_active: params[:sfdc_cont_active], sfdc_tier: params[:sfdc_tier], domain: params[:domain], acct_name: params[:acct_name], group_name: params[:group_name], ult_group_name: params[:ult_group_name], street: params[:street], city: params[:city], state: params[:state], zip: params[:zip], fname: params[:fname], fullname: params[:fullname], job: params[:job], job_raw: params[:job_raw], email: params[:email], influence: params[:influence], cell_phone: params[:cell_phone], last_activity_date: params[:last_activity_date], created_date: params[:created_date], updated_date: params[:updated_date], franchise: params[:franchise], view_mode: params[:view_mode]})
        redirect_to staffers_path
    end

    def search_result_location
        set_selected_status_location({ latitude: params[:latitude], longitude: params[:longitude], created_at: params[:created_at], updated_at: params[:updated_at], city: params[:city], state_code: params[:state_code], postal_code: params[:postal_code], coordinates: params[:coordinates], acct_name: params[:acct_name], group_name: params[:group_name], ult_group_name: params[:ult_group_name], source: params[:source], sfdc_id: params[:sfdc_id], tier: params[:tier], sales_person: params[:sales_person], acct_type: params[:acct_type], location_status: params[:location_status], url: params[:url], street: params[:street], address: params[:address], view_mode: params[:view_mode], temporary_id: params[:temporary_id], geo_acct_name: params[:geo_acct_name], geo_full_addr: params[:geo_full_addr], crm_source: params[:crm_source], geo_franch_cons: params[:geo_franch_cons], geo_franch_cat: params[:geo_franch_cat], crm_franch_cons: params[:crm_franch_cons], crm_franch_cat: params[:crm_franch_cat], geo_root: params[:geo_root], crm_root: params[:crm_root], crm_url: params[:crm_url]})
        redirect_to locations_path
    end












    # == Google API Testing Search Methods - Starts ===

    # == Testing MY Google API - Search Method V1 - Perfect! ==
    # def test_encoded_search
    #     q = "automobile dealerships in hawaii"
    # end
    # == Testing MY Google API - Search Method V1 - Ends  ==

    # == Testing MY Google API - Search Method V2 ==
    def test_encoded_search
        # q = "automobile dealerships in hawaii"

        #-----------------
        acct = "Larry H. Miller Hyundai Peoria"
        street = "8425 W Bell Rd"
        city = "Peoria"
        state = "AZ"

        #-----------------
        # if acct != nil
            acct_gs = acct.gsub(/[ ]/, '%20')
            acct_q = "#{acct_gs}+"
        # end
        # if street != nil
            street_gs = street.gsub(/[ ]/, '%20')
            street_q = "#{street_gs}+"
        # end
        # if city != nil
            city_gs = city.gsub(/[ ]/, '%20')
            city_q = "#{city_gs}+"
        # end
        # if state != nil
            state_st = state
        # end

        #-----------------
        # q = "#{acct}#{city},#{state}"


        # num = "&num=100"
        # client = "&client=google-csbe"
        # key = "&cx=016494735141549134606:xzyw78w1vn0"
        # tag1 = "&as_oq=auto+automobile+car+cars+vehicle+vehicles"
        # tag2 = "&as_oq=dealer+dealership+group"

        # q_combinded = "q=#{acct_q}#{street_q}#{city_q}#{state_st}"
        # acct_req = "&as_epq=#{acct_gs}"
        # acct_opt = "&oq=#{acct_gs}"

        # q = "#{acct_q}#{street_q}#{city_q}#{state_st}"
        # q = "#{acct}#{street}#{city}#{state}#{num}"
        # q = "automobile dealerships in hawaii"

    end
    # == Testing MY Google API - Search Method V2 - Ends  ==

    # == Google API Testing Search Methods - Ends ===

    private

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
