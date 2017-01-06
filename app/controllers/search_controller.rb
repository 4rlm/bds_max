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

        #========================
        # Core (Accounts) Instance Variables
        #========================

        # Core All
        @core_all = Core.count
        #============

        # Core BDS Status
        @core_bds_status_imported = Core.where(bds_status: "Imported").count
        @core_bds_status_queue_domainer = Core.where(bds_status: "Queue Domainer").count
        @core_bds_status_dom_result = Core.where(bds_status: "Dom Result").count
        @core_bds_status_matched = Core.where(bds_status: "Matched").count
        @core_bds_status_no_matches = Core.where(bds_status: "No Matches").count
        @core_bds_status_queue_indexer = Core.where(bds_status: "Queue Indexer").count
        @core_bds_status_indexer_result = Core.where(bds_status: "Indexer Result").count


        #============

        # Core URL Comparison
        @urls_updated = Core.where(url_comparison: "Different").count
        @roots_updated = Core.where(root_comparison: "Different").count
        #============

        # Core Salesperson
        @core_sp_peckler = Core.where(sfdc_sales_person: "Marc Peckler").count
        @core_sp_rosen = Core.where(sfdc_sales_person: "Ben Rosen").count
        @core_sp_price = Core.where(sfdc_sales_person: "Jason Price").count
        @core_sp_thompson = Core.where(sfdc_sales_person: "Sarah Thompson").count
        @core_sp_huffmeyer = Core.where(sfdc_sales_person: "Justin Hufmeyer").count
        #============

        # Core Type
        @core_type_canceled = Core.where(sfdc_type: "Canceled").count
        @core_type_current_account = Core.where(sfdc_type: "Current Account").count
        @core_type_current_sub_account = Core.where(sfdc_type: "Current Sub-account").count
        @core_type_distribution_partner = Core.where(sfdc_type: "Distribution Partner").count
        @core_type_do_not_solicit = Core.where(sfdc_type: "Do Not Solicit").count
        @core_type_failure_to_launch = Core.where(sfdc_type: "Failure To Launch").count
        @core_type_group_division = Core.where(sfdc_type: "Group Division").count
        @core_type_group_name = Core.where(sfdc_type: "Group Name").count
        @core_type_inactive = Core.where(sfdc_type: "Inactive").count
        @core_type_influencer = Core.where(sfdc_type: "Influencer").count
        @core_type_max_digital_demo_store = Core.where(sfdc_type: "Max Digital Demo Store").count
        @core_type_prospect = Core.where(sfdc_type: "Prospect").count
        @core_type_prospect_sub_account = Core.where(sfdc_type: "Prospect Sub-account").count
        @core_type_vendor = Core.where(sfdc_type: "Vendor").count
        #============

        # Core Sales Tier
        @core_tier_1 = Core.where(sfdc_tier: "Tier 1").count
        @core_tier_2 = Core.where(sfdc_tier: "Tier 2").count
        @core_tier_3 = Core.where(sfdc_tier: "Tier 3").count
        @core_tier_4 = Core.where(sfdc_tier: "Tier 4").count
        @core_tier_5 = Core.where(sfdc_tier: "Tier 5").count
        #============

        # URL Comparison
        @core_url_comparison_same = Core.where(url_comparison: "Same").count
        @core_url_comparison_different = Core.where(url_comparison: "Different").count
        @core_root_comparison_same = Core.where(root_comparison: "Same").count
        @core_root_comparison_different = Core.where(root_comparison: "Different").count
        #============

        # Count per Franchise Term - sfdc
        @core_sfdc_franchise = Core.where.not(sfdc_franchise: nil).count
        @core_sfdc_acura = Core.where("sfdc_franchise LIKE ?", "%Acura%").count
        @core_sfdc_alfa = Core.where("sfdc_franchise LIKE ?", "%Alfa%").count
        @core_sfdc_aston = Core.where("sfdc_franchise LIKE ?", "%Aston%").count
        @core_sfdc_audi = Core.where("sfdc_franchise LIKE ?", "%Audi%").count
        @core_sfdc_bentley = Core.where("sfdc_franchise LIKE ?", "%Bentley%").count
        @core_sfdc_benz = Core.where("sfdc_franchise LIKE ?", "%Benz%").count
        @core_sfdc_bmw = Core.where("sfdc_franchise LIKE ?", "%Bmw%").count
        @core_sfdc_bugatti = Core.where("sfdc_franchise LIKE ?", "%Bugatti%").count
        @core_sfdc_buick = Core.where("sfdc_franchise LIKE ?", "%Buick%").count
        @core_sfdc_cadillac = Core.where("sfdc_franchise LIKE ?", "%Cadillac%").count

        @core_sfdc_cdjr = Core.where("sfdc_franchise LIKE ?", "%Cdjr%").count
        @core_sfdc_chev = Core.where("sfdc_franchise LIKE ?", "%Chev%").count
        @core_sfdc_chevrolet = Core.where("sfdc_franchise LIKE ?", "%Chevrolet%").count
        @core_sfdc_chevy = Core.where("sfdc_franchise LIKE ?", "%Chevy%").count
        @core_sfdc_chrysler = Core.where("sfdc_franchise LIKE ?", "%Chrysler%").count
        @core_sfdc_cjd = Core.where("sfdc_franchise LIKE ?", "%Cjd%").count
        @core_sfdc_corvette = Core.where("sfdc_franchise LIKE ?", "%Corvette%").count
        @core_sfdc_daewoo = Core.where("sfdc_franchise LIKE ?", "%Daewoo%").count
        @core_sfdc_dodge = Core.where("sfdc_franchise LIKE ?", "%Dodge%").count
        @core_sfdc_ferrari = Core.where("sfdc_franchise LIKE ?", "%Ferrari%").count
        @core_sfdc_fiat = Core.where("sfdc_franchise LIKE ?", "%Fiat%").count
        @core_sfdc_ford = Core.where("sfdc_franchise LIKE ?", "%Ford%").count
        @core_sfdc_gm = Core.where("sfdc_franchise LIKE ?", "%Gm%").count
        @core_sfdc_gmc = Core.where("sfdc_franchise LIKE ?", "%Gmc%").count
        @core_sfdc_honda = Core.where("sfdc_franchise LIKE ?", "%Honda%").count
        @core_sfdc_hummer = Core.where("sfdc_franchise LIKE ?", "%Hummer%").count
        @core_sfdc_hyundai = Core.where("sfdc_franchise LIKE ?", "%Hyundai%").count
        @core_sfdc_infiniti = Core.where("sfdc_franchise LIKE ?", "%Infiniti%").count
        @core_sfdc_isuzu = Core.where("sfdc_franchise LIKE ?", "%Isuzu%").count
        @core_sfdc_jaguar = Core.where("sfdc_franchise LIKE ?", "%Jaguar%").count
        @core_sfdc_jeep = Core.where("sfdc_franchise LIKE ?", "%Jeep%").count
        @core_sfdc_kia = Core.where("sfdc_franchise LIKE ?", "%Kia%").count
        @core_sfdc_lamborghini = Core.where("sfdc_franchise LIKE ?", "%Lamborghini%").count
        @core_sfdc_lexus = Core.where("sfdc_franchise LIKE ?", "%Lexus%").count
        @core_sfdc_lincoln = Core.where("sfdc_franchise LIKE ?", "%Lincoln%").count
        @core_sfdc_lotus = Core.where("sfdc_franchise LIKE ?", "%Lotus%").count
        @core_sfdc_maserati = Core.where("sfdc_franchise LIKE ?", "%Maserati%").count
        @core_sfdc_mazda = Core.where("sfdc_franchise LIKE ?", "%Mazda%").count
        @core_sfdc_mb = Core.where("sfdc_franchise LIKE ?", "%Mb%").count
        @core_sfdc_mclaren = Core.where("sfdc_franchise LIKE ?", "%Mclaren%").count
        @core_sfdc_mercedes = Core.where("sfdc_franchise LIKE ?", "%Mercedes%").count
        @core_sfdc_mercury = Core.where("sfdc_franchise LIKE ?", "%Mercury%").count
        @core_sfdc_mini = Core.where("sfdc_franchise LIKE ?", "%Mini%").count
        @core_sfdc_mitsubishi = Core.where("sfdc_franchise LIKE ?", "%Mitsubishi%").count
        @core_sfdc_nissan = Core.where("sfdc_franchise LIKE ?", "%Nissan%").count
        @core_sfdc_oldsmobile = Core.where("sfdc_franchise LIKE ?", "%Oldsmobile%").count
        @core_sfdc_plymouth = Core.where("sfdc_franchise LIKE ?", "%Plymouth%").count
        @core_sfdc_pontiac = Core.where("sfdc_franchise LIKE ?", "%Pontiac%").count
        @core_sfdc_porsche = Core.where("sfdc_franchise LIKE ?", "%Porsche%").count
        @core_sfdc_ram = Core.where("sfdc_franchise LIKE ?", "%Ram%").count
        @core_sfdc_range = Core.where("sfdc_franchise LIKE ?", "%Range%").count
        @core_sfdc_rolls = Core.where("sfdc_franchise LIKE ?", "%Rolls%").count
        @core_sfdc_rover = Core.where("sfdc_franchise LIKE ?", "%Rover%").count
        @core_sfdc_royce = Core.where("sfdc_franchise LIKE ?", "%Royce%").count
        @core_sfdc_saab = Core.where("sfdc_franchise LIKE ?", "%Saab%").count
        @core_sfdc_saturn = Core.where("sfdc_franchise LIKE ?", "%Saturn%").count
        @core_sfdc_scion = Core.where("sfdc_franchise LIKE ?", "%Scion%").count
        @core_sfdc_smart = Core.where("sfdc_franchise LIKE ?", "%Smart%").count
        @core_sfdc_subaru = Core.where("sfdc_franchise LIKE ?", "%Subaru%").count
        @core_sfdc_suzuki = Core.where("sfdc_franchise LIKE ?", "%Suzuki%").count
        @core_sfdc_toyota = Core.where("sfdc_franchise LIKE ?", "%Toyota%").count
        @core_sfdc_volkswagen = Core.where("sfdc_franchise LIKE ?", "%Volkswagen%").count
        @core_sfdc_volvo = Core.where("sfdc_franchise LIKE ?", "%Volvo%").count
        @core_sfdc_vw = Core.where("sfdc_franchise LIKE ?", "%Vw%").count

        # Count per Franchise Term - site
        @core_site_franchise = Core.where.not(site_franchise: nil).count
        @core_site_acura = Core.where("site_franchise LIKE ?", "%Acura%").count
        @core_site_alfa = Core.where("site_franchise LIKE ?", "%Alfa%").count
        @core_site_aston = Core.where("site_franchise LIKE ?", "%Aston%").count
        @core_site_audi = Core.where("site_franchise LIKE ?", "%Audi%").count
        @core_site_bentley = Core.where("site_franchise LIKE ?", "%Bentley%").count
        @core_site_benz = Core.where("site_franchise LIKE ?", "%Benz%").count
        @core_site_bmw = Core.where("site_franchise LIKE ?", "%Bmw%").count
        @core_site_bugatti = Core.where("site_franchise LIKE ?", "%Bugatti%").count
        @core_site_buick = Core.where("site_franchise LIKE ?", "%Buick%").count
        @core_site_cadillac = Core.where("site_franchise LIKE ?", "%Cadillac%").count

        @core_site_cdjr = Core.where("site_franchise LIKE ?", "%Cdjr%").count
        @core_site_chev = Core.where("site_franchise LIKE ?", "%Chev%").count
        @core_site_chevrolet = Core.where("site_franchise LIKE ?", "%Chevrolet%").count
        @core_site_chevy = Core.where("site_franchise LIKE ?", "%Chevy%").count
        @core_site_chrysler = Core.where("site_franchise LIKE ?", "%Chrysler%").count
        @core_site_cjd = Core.where("site_franchise LIKE ?", "%Cjd%").count
        @core_site_corvette = Core.where("site_franchise LIKE ?", "%Corvette%").count
        @core_site_daewoo = Core.where("site_franchise LIKE ?", "%Daewoo%").count
        @core_site_dodge = Core.where("site_franchise LIKE ?", "%Dodge%").count
        @core_site_ferrari = Core.where("site_franchise LIKE ?", "%Ferrari%").count
        @core_site_fiat = Core.where("site_franchise LIKE ?", "%Fiat%").count
        @core_site_ford = Core.where("site_franchise LIKE ?", "%Ford%").count
        @core_site_gm = Core.where("site_franchise LIKE ?", "%Gm%").count
        @core_site_gmc = Core.where("site_franchise LIKE ?", "%Gmc%").count
        @core_site_honda = Core.where("site_franchise LIKE ?", "%Honda%").count
        @core_site_hummer = Core.where("site_franchise LIKE ?", "%Hummer%").count
        @core_site_hyundai = Core.where("site_franchise LIKE ?", "%Hyundai%").count
        @core_site_infiniti = Core.where("site_franchise LIKE ?", "%Infiniti%").count
        @core_site_isuzu = Core.where("site_franchise LIKE ?", "%Isuzu%").count
        @core_site_jaguar = Core.where("site_franchise LIKE ?", "%Jaguar%").count
        @core_site_jeep = Core.where("site_franchise LIKE ?", "%Jeep%").count
        @core_site_kia = Core.where("site_franchise LIKE ?", "%Kia%").count
        @core_site_lamborghini = Core.where("site_franchise LIKE ?", "%Lamborghini%").count
        @core_site_lexus = Core.where("site_franchise LIKE ?", "%Lexus%").count
        @core_site_lincoln = Core.where("site_franchise LIKE ?", "%Lincoln%").count
        @core_site_lotus = Core.where("site_franchise LIKE ?", "%Lotus%").count
        @core_site_maserati = Core.where("site_franchise LIKE ?", "%Maserati%").count
        @core_site_mazda = Core.where("site_franchise LIKE ?", "%Mazda%").count
        @core_site_mb = Core.where("site_franchise LIKE ?", "%Mb%").count
        @core_site_mclaren = Core.where("site_franchise LIKE ?", "%Mclaren%").count
        @core_site_mercedes = Core.where("site_franchise LIKE ?", "%Mercedes%").count
        @core_site_mercury = Core.where("site_franchise LIKE ?", "%Mercury%").count
        @core_site_mini = Core.where("site_franchise LIKE ?", "%Mini%").count
        @core_site_mitsubishi = Core.where("site_franchise LIKE ?", "%Mitsubishi%").count
        @core_site_nissan = Core.where("site_franchise LIKE ?", "%Nissan%").count
        @core_site_oldsmobile = Core.where("site_franchise LIKE ?", "%Oldsmobile%").count
        @core_site_plymouth = Core.where("site_franchise LIKE ?", "%Plymouth%").count
        @core_site_pontiac = Core.where("site_franchise LIKE ?", "%Pontiac%").count
        @core_site_porsche = Core.where("site_franchise LIKE ?", "%Porsche%").count
        @core_site_ram = Core.where("site_franchise LIKE ?", "%Ram%").count
        @core_site_range = Core.where("site_franchise LIKE ?", "%Range%").count
        @core_site_rolls = Core.where("site_franchise LIKE ?", "%Rolls%").count
        @core_site_rover = Core.where("site_franchise LIKE ?", "%Rover%").count
        @core_site_royce = Core.where("site_franchise LIKE ?", "%Royce%").count
        @core_site_saab = Core.where("site_franchise LIKE ?", "%Saab%").count
        @core_site_saturn = Core.where("site_franchise LIKE ?", "%Saturn%").count
        @core_site_scion = Core.where("site_franchise LIKE ?", "%Scion%").count
        @core_site_smart = Core.where("site_franchise LIKE ?", "%Smart%").count
        @core_site_subaru = Core.where("site_franchise LIKE ?", "%Subaru%").count
        @core_site_suzuki = Core.where("site_franchise LIKE ?", "%Suzuki%").count
        @core_site_toyota = Core.where("site_franchise LIKE ?", "%Toyota%").count
        @core_site_volkswagen = Core.where("site_franchise LIKE ?", "%Volkswagen%").count
        @core_site_volvo = Core.where("site_franchise LIKE ?", "%Volvo%").count
        @core_site_vw = Core.where("site_franchise LIKE ?", "%Vw%").count

        # Count per General Term - sfdc
        @core_sfdc_auto = Core.where("sfdc_franchise LIKE ?", "%Auto%").count
        @core_sfdc_autogroup = Core.where("sfdc_franchise LIKE ?", "%Autogroup%").count
        @core_sfdc_automall = Core.where("sfdc_franchise LIKE ?", "%Automall%").count
        @core_sfdc_automotive = Core.where("sfdc_franchise LIKE ?", "%Automotive%").count
        @core_sfdc_autoplex = Core.where("sfdc_franchise LIKE ?", "%Autoplex%").count
        @core_sfdc_autos = Core.where("sfdc_franchise LIKE ?", "%Autos%").count
        @core_sfdc_autosales = Core.where("sfdc_franchise LIKE ?", "%Autosales%").count
        @core_sfdc_cars = Core.where("sfdc_franchise LIKE ?", "%Cars%").count
        @core_sfdc_dealer = Core.where("sfdc_franchise LIKE ?", "%Dealer%").count
        @core_sfdc_imports = Core.where("sfdc_franchise LIKE ?", "%Imports%").count
        @core_sfdc_group = Core.where("sfdc_franchise LIKE ?", "%Group%").count
        @core_sfdc_highline = Core.where("sfdc_franchise LIKE ?", "%Highline%").count
        @core_sfdc_motor = Core.where("sfdc_franchise LIKE ?", "%Motor%").count
        @core_sfdc_motors = Core.where("sfdc_franchise LIKE ?", "%Motors%").count
        @core_sfdc_superstore = Core.where("sfdc_franchise LIKE ?", "%Superstore%").count
        @core_sfdc_trucks = Core.where("sfdc_franchise LIKE ?", "%Trucks%").count
        @core_sfdc_usedcars = Core.where("sfdc_franchise LIKE ?", "%Usedcars%").count

        # Count per General Term - sfdc
        @core_site_auto = Core.where("site_franchise LIKE ?", "%Auto%").count
        @core_site_autogroup = Core.where("site_franchise LIKE ?", "%Autogroup%").count
        @core_site_automall = Core.where("site_franchise LIKE ?", "%Automall%").count
        @core_site_automotive = Core.where("site_franchise LIKE ?", "%Automotive%").count
        @core_site_autoplex = Core.where("site_franchise LIKE ?", "%Autoplex%").count
        @core_site_autos = Core.where("site_franchise LIKE ?", "%Autos%").count
        @core_site_autosales = Core.where("site_franchise LIKE ?", "%Autosales%").count
        @core_site_cars = Core.where("site_franchise LIKE ?", "%Cars%").count
        @core_site_dealer = Core.where("site_franchise LIKE ?", "%Dealer%").count
        @core_site_imports = Core.where("site_franchise LIKE ?", "%Imports%").count
        @core_site_group = Core.where("site_franchise LIKE ?", "%Group%").count
        @core_site_highline = Core.where("site_franchise LIKE ?", "%Highline%").count
        @core_site_motor = Core.where("site_franchise LIKE ?", "%Motor%").count
        @core_site_motors = Core.where("site_franchise LIKE ?", "%Motors%").count
        @core_site_superstore = Core.where("site_franchise LIKE ?", "%Superstore%").count
        @core_site_trucks = Core.where("site_franchise LIKE ?", "%Trucks%").count
        @core_site_usedcars = Core.where("site_franchise LIKE ?", "%Usedcars%").count



        #============

        # Analysis
        # franchise dealers

        #========================
        # Gcse (Domainer) Instance Variables
        #========================

        # Gcse All
        @gcse_all = Gcse.count

        # Domainer Queries
        @gcse_query_count = get_domainer_query_count
        @gcse_domain_status_dom_result = Gcse.where(domain_status: "Dom Result").count
        @gcse_domain_status_no_auto_matches = Gcse.where(domain_status: "No Auto-Matches").count

        #========================
        # Discoveries Instance Variables
        #========================
        # Solitary All
         @solitary_all = Solitary.count

        #  Pending Verification All
        @pending_verification_all = PendingVerification.count

         #========================
         # IndexerStaffs Instance Variables
         #========================
         @indexer_staff_all = IndexerStaff.count
         @indexer_staff_status_matched = IndexerStaff.where(indexer_status: "Matched").count
         @indexer_staff_status_no_matches = IndexerStaff.where(indexer_status: "No Matches").count
         @indexer_staff_status_error = IndexerStaff.where(indexer_status: "Error").count
         @indexer_staff_status_try_again = IndexerStaff.where(indexer_status: "Try Again").count
         @indexer_staff_status_verified = IndexerStaff.where(indexer_status: "Verified").count
         @indexer_staff_status_ready = IndexerStaff.where(indexer_status: "Ready").count

         #========================
         # IndexerLocations Instance Variables
         #========================
         @indexer_location_all = IndexerLocation.count

         @indexer_location_status_matched = IndexerLocation.where(indexer_status: "Matched").count
         @indexer_location_status_no_matches = IndexerLocation.where(indexer_status: "No Matches").count
         @indexer_location_status_error = IndexerLocation.where(indexer_status: "Error").count
         @indexer_location_status_try_again = IndexerLocation.where(indexer_status: "Try Again").count
         @indexer_location_status_verified = IndexerLocation.where(indexer_status: "Verified").count
         @indexer_location_status_ready = IndexerLocation.where(indexer_status: "Ready").count

         #========================
         # Staffers (Contacts) Instance Variables
         #========================
         @staffer_all = Staffer.count

        #  staffer_status


    end

    def dashboard
    end

    def search_result_core
        set_selected_status_core({bds_status: params[:bds_status], url_comparison: params[:url_comparison], root_comparison: params[:root_comparison], sfdc_type: params[:sfdc_type], sfdc_sales_person: params[:sfdc_sales_person], sfdc_tier: params[:sfdc_tier], sfdc_ult_grp: params[:sfdc_ult_grp], sfdc_group: params[:sfdc_group], sfdc_city: params[:sfdc_city], sfdc_state: params[:sfdc_state], sfdc_zip: params[:sfdc_zip], sfdc_acct: params[:sfdc_acct], sfdc_id: params[:sfdc_id], sfdc_ph: params[:sfdc_ph], staff_indexer_status: params[:staff_indexer_status], location_indexer_status: params[:location_indexer_status], staffer_status: params[:staffer_status], inventory_indexer_status: params[:inventory_indexer_status],  sfdc_ult_rt: params[:sfdc_ult_rt],  sfdc_grp_rt: params[:sfdc_grp_rt],  sfdc_street: params[:sfdc_street],  sfdc_url: params[:sfdc_url],  matched_url: params[:matched_url],  matched_root: params[:matched_root],  sfdc_root: params[:sfdc_root],  site_acct: params[:site_acct],  site_group: params[:site_group],  site_ult_grp: params[:site_ult_grp],  site_tier: params[:site_tier],  site_grp_rt: params[:site_grp_rt],  site_ult_rt: params[:site_ult_rt],  acct_indicator: params[:acct_indicator],  grp_name_indicator: params[:grp_name_indicator],  ult_grp_name_indicator: params[:ult_grp_name_indicator],  tier_indicator: params[:tier_indicator],  grp_rt_indicator: params[:grp_rt_indicator],  ult_grp_rt_indicator: params[:ult_grp_rt_indicator],  site_street: params[:site_street], site_city: params[:site_city],  site_state: params[:site_state],  site_zip: params[:site_zip],  site_ph: params[:site_ph],  street_indicator: params[:street_indicator],  city_indicator: params[:city_indicator],  state_indicator: params[:state_indicator],  zip_indicator: params[:zip_indicator],  ph_indicator: params[:ph_indicator] })
        redirect_to cores_path
    end

    def search_result_gcse
        set_selected_status_gcse({domain_status: params[:domain_status], gcse_result_num: params[:gcse_result_num], gcse_timestamp: params[:gcse_timestamp], sfdc_ult_acct: params[:sfdc_ult_acct], sfdc_acct: params[:sfdc_acct], sfdc_type: params[:sfdc_type], sfdc_city: params[:sfdc_city], sfdc_state: params[:sfdc_state], sfdc_id: params[:sfdc_id], sfdc_url_o: params[:sfdc_url_o], domain: params[:domain], root: params[:root], sfdc_root: params[:sfdc_root]})
        redirect_to gcses_path
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
