require 'open-uri'
require 'mechanize'
require 'uri'
require 'date'

class CoreService

    # == Core Method starts here.===================|*|
    def scrape_listing(ids)  # search
        agent = Mechanize.new

        # == Create Counters ======================
        search_query_num = 0
        # url_grand_count = 0

        # == Create variables from Core table ==========
        Core.where(id: ids).each do |el|
            id = el[:sfdc_id]
            ult_acct = el[:sfdc_ult_grp]
            acct = el[:sfdc_acct]
            type = el[:sfdc_type]
            street = el[:sfdc_street]
            city = el[:sfdc_city]
            state = el[:sfdc_state]
            zip = el[:sfdc_zip]
            url_o = el[:sfdc_url]

            #-- Split for sfdc_root ---**********new***Test
            sfdc_root = url_o

            unless sfdc_root == nil
                if sfdc_root.include?('//')
                    sfdc_root = sfdc_root.split("//")
                    sfdc_root = sfdc_root[1]
                else
                    sfdc_root
                end

                if sfdc_root.include?('www')
                    sfdc_root = sfdc_root.split(".")
                    sfdc_root = sfdc_root[1]
                else
                    sfdc_root
                end

                if sfdc_root.include?('.')
                    sfdc_root = sfdc_root.split(".")
                    sfdc_root = sfdc_root[0]
                else
                    sfdc_root
                end
            end
            #-- Split for sfdc_root ---Ends **********new***Test

            # Set the time when "el" is being searched.
            current_time = Time.new

            #=== Encoded Search ========================
            # ----- Formatting ------------------------------------------------
            if acct != nil
                acct_gs = acct.gsub(/[ ]/, '%20')
                acct_q = "#{acct_gs}+"
            end
            if street != nil
                street_gs = street.gsub(/[ ]/, '%20')
                street_q = "#{street_gs}+"
            end
            if city != nil
                city_gs = city.gsub(/[ ]/, '%20')
                city_q = "#{city_gs}+"
            end
            if state != nil
                state_st = "#{state}+"
            end
            if zip != nil
                zip_st = zip
            end

            # ----- Encoding Begins ------ Original --------------
            # url = "http://www.google.com/search?"
            # num = "&num=1000"
            # client = "&client=google-csbe"
            # key = "&cx=016494735141549134606:xzyw78w1vn0"
            # tag1 = "&as_oq=auto+automobile+car+cars+vehicle+vehicles"
            # tag2 = "&as_oq=dealer+dealership+group"
            #
            # q_combinded = "q=#{acct_q}#{street_q}#{city_q}#{state_st}"
            # acct_req = "&as_epq=#{acct_gs}"
            # acct_opt = "&oq=#{acct_gs}"
            #
            # url_encoded = "#{url}#{q_combinded}#{num}#{client}#{key}"
            #=== End - Encoded Search == Original =======


            #== Starts - Google Encoded Search == Testing 1-- Starts ==
            url = "http://localhost:3000/search?utf8=%E2%9C%93&"
            # url = "http://localhost:3000/search?"
            # num = "&num=90"

            # Temporarily disabled long query.
            # q_combinded = "q=#{acct_q}#{street_q}#{city_q}#{state_st}#{zip_st}"

            # Temporaily created shorter query.
            q_combinded = "q=#{acct_q}#{city_q}#{state_st}#{zip_st}"

            url_encoded = "#{url}#{q_combinded}"
            #== Ends - Google Encoded Search == Testing 2-- Ends ==

            begin #begin rescue p1 *******************************
                # == Loop (1): through each encoded search url. ======
                agent.get(url_encoded) do |page|
                    search_query_num += 1
                    # === TESTING: ROOT COUNTER (TOP) ===
                    root_count_array = []
                    # === END - TESTING: ROOT COUNTER (TOP) ===

                    # == Loop (2): through each link in results of each encoded search. ==
                    page.links.each.with_index(1) do |link, url_export_num|
                        # url_grand_count += 1  # *Grand total*

                        # == Counter (2-3) =======================

                        # == Variables: Send link url to URI gem and get text of link.==
                        uri = URI(link.href.to_s)
                        text = link.text.downcase

                        # == IF: Only get http/s urls. ==================
                        if uri.class.to_s == "URI::HTTP" || uri.class.to_s == "URI::HTTPS"
                            # text = URI(link.text.to_s)
                            schemec = uri.scheme
                            hostc = uri.host

                            #-- Split for Domain Suffix ---
                            root = hostc.split('.')[-2]
                            host_split = hostc.split('.')[-1]
                            suffix = ".#{host_split}"

                            domain = schemec + "://" + hostc + "/"

                            # == CSV Filter: 1_exclude_root
                            # If 'root' is NOT included in the ExcludeRoot table,
                            # then the root will create a new row in GCSE table.
                            good_roots = !ExcludeRoot.all.map(&:term).include?(root)
                            good_suffixes = [".com", ".net"].include?(suffix)

                            if good_roots && good_suffixes && check_good_in_host_del(hostc)
                                #== CSV Filter: 5_in_host_pos
                                host_pos = []
                                InHostPo.all.map(&:term).each do |term|
                                    host_pos << term if hostc.include?(term)
                                end
                                in_host_pos = host_pos.empty? ? '(blank)' : host_pos.join('; ')
                                #============================

                                #== CSV Filter: 6_in_text_del
                                text_del = []
                                InTextDel.all.map(&:term).each do |term|
                                    text_del << term if text.include?(term)
                                end
                                in_text_del = text_del.empty? ? '(blank)' : text_del.join('; ')
                                #============================

                                #== CSV Filter: 8_in_text_pos
                                text_pos = []
                                InTextPo.all.map(&:term).each do |term|
                                    text_pos << term if text.include?(term)
                                end
                                in_text_pos = text_pos.empty? ? '(blank)' : text_pos.join('; ')
                                #============================

                                # === ROOT COUNTER (BOTTOM) ===
                                root_count_array << root
                                root_counter = root_count_array.count(root)

                                if root_counter == 1
                                    # Create new Gsce objects
                                    add_data_row(current_time, search_query_num, url_export_num, id, ult_acct, acct, type, street, city, state, url_o, sfdc_root, root, domain, root_counter, suffix, in_host_pos, text, in_text_pos, in_text_del)
                                end
                            end # Ends: unless ExcludeRoot.all.map(&:term).include?(root)
                        end # Ends: if uri.class.to_s
                    end # Ends: page.links.each
                end # Ends: agent.get(url_encoded)


            rescue  #begin rescue p2
                $!.message
                bad_connection = "Google Search Error!"

                #== Rescue Throttle (if needed) =====================
                forced_delay_time = (15..20).to_a.sample
                puts "--------------------------------"
                puts bad_connection
                puts "--------------------------------"
                puts "Forced Delay for #{forced_delay_time} seconds."
                puts "--------------------------------"
                sleep(forced_delay_time)
                puts $!.message
            end  #end rescue

            #==== Update Core Object ========================
            # el is from Core.where(id: ids)
            # Update "domainer_date" column of the queued Core objects.
            el.update_attributes(domainer_date: current_time, bds_status: "Dom Result", sfdc_root: sfdc_root)


            #== Throttle (if needed) =====================
            throttle_delay_time = (1..2).to_a.sample
            puts "--------------------------------"
            puts "SFDC_ID: #{id}"
            puts "ACCT NAME: #{acct}"
            puts "SFDC_URL: #{url_o}"
            puts "SFDC_ROOT: #{sfdc_root}"
            puts "--------------------------------"
            puts "Please wait #{throttle_delay_time} seconds."
            puts "--------------------------------"
            sleep(throttle_delay_time)


        end # Ends Core.all.each
    end # Ends scrape_listing  # search

    # "root_counter" variable will be added later after adding root_counter column.
    def add_data_row(datetime, search_query_num, url_export_num, id, ult_acct, acct, type, street, city, state, url_o, sfdc_root, root, domain, root_counter, suffix, in_host_pos, text, in_text_pos, in_text_del)
        gcse = Gcse.new(
            gcse_timestamp: datetime,
            gcse_query_num: search_query_num,
            gcse_result_num: url_export_num,
            sfdc_id: id,
            sfdc_ult_acct: ult_acct,
            sfdc_acct: acct,
            sfdc_type: type,
            sfdc_street: street,
            sfdc_city: city,
            sfdc_state: state,
            domain_status: "Dom Result",
            sfdc_url_o: url_o,
            sfdc_root: sfdc_root,
            root: root,
            domain: domain,
            root_counter: root_counter,
            suffix: suffix,
            in_host_pos: in_host_pos,
            text: text,
            in_text_pos: in_text_pos,
            in_text_del: in_text_del
        )
        gcse.save
    end  # Ends add_data_row

    def check_good_in_host_del(hostc)
        InHostDel.all.map(&:term).each do |term|
            return false if hostc.include?(term)
        end
        true
    end

    ### FRANCHISER METHODS FOR BUTTONS - STARTS ###
    def franchise_resetter
        ## Step1: DELETES FRANCHISE DATA IN CORES
        # cores = Core.all[0..1]
        cores = Core.all
        counter_reset = 1
        cores.each do |core|
            core.update_attributes(sfdc_franchise: nil, sfdc_franch_cons: nil, sfdc_franch_cat: nil)
            puts "Resetting Franchise Values: #{counter_reset}"
            counter_reset +=1
        end
    end  ## franchise_resetter ends.

    def franchise_termer
        # Loop Entire Core through Each Franchise Term Row. ##
        # brands = InHostPo.all[19..21]
        brands = InHostPo.all

        counter_brand = 0
        counter_termer = 0
        brands.each do |brand|
            sfdc_cores = Core.where("sfdc_acct LIKE '%#{brand.term}%' OR  sfdc_acct LIKE '%#{brand.term.capitalize}%' OR sfdc_root LIKE '%#{brand.term}%' OR sfdc_root LIKE '%#{brand.term.capitalize}%'")
            puts "==============================="
            puts "Looping Brands: #{counter_brand} for #{brand.term}"

            sfdc_cores.each do |core|
                puts "--------------------------------"
                puts "URL: #{core.sfdc_url}"
                puts "Source: #{core.acct_source}"
                puts "Current Franchise: #{core.sfdc_franchise}"
                counter_brand +=1
                franchises = []
                term = brand.term
                sfdc_franch = core.sfdc_franchise

                if sfdc_franch
                    if sfdc_franch.include?(';')
                        franchises = sfdc_franch.split(';')
                    else
                        franchises << sfdc_franch
                    end
                end

                franchises << term
                franchises.sort!
                uniq_franchises = franchises.uniq

                if uniq_franchises.length > 0
                    final_result = uniq_franchises.join(";")
                else
                    final_result = uniq_franchises[0]
                end

                # core.update_attribute(:sfdc_franchise, nil)
                core.update_attribute(:sfdc_franchise, final_result)
                puts "Updating Brand: #{brand.term}"
                puts "Brand Count: #{counter_brand}"
                puts "Franchise Termer: #{counter_termer}"
                counter_termer +=1

            end  ## sfdc_cores.each loops ends ##
        end  ## brands.each loop ends.
    end  ## franchise_termer method ends ##

    def franchise_consolidator
        # cores = Core.where.not(sfdc_franchise: nil)[0..100]
        cores = Core.where(acct_source: "Cop")
        counter_consolidator = 1
        cores.each do |core|

            unless core.sfdc_franchise == nil

                sfdc_terms = core.sfdc_franchise.split(';')
                franch_cons_arr = []
                core_franch_cons = core.sfdc_franch_cons

                franch_cat_arr = []
                core_category = core.sfdc_franch_cat

                # New feature (like franchise_termer) adds sfdc data to arr.
                if core_franch_cons
                    franch_cons_arr = core_franch_cons.split(';')
                end

                if core_category
                    franch_cat_arr = core_category.split(';')
                end

                # Loops each sfdc_franchise term.
                sfdc_terms.each do |sfdc_term|
                    # Assigns InHostPo term to variable.
                    in_host_po = InHostPo.find_by(term: sfdc_term.downcase)

                    # Adds InHostPo consolidated_term to franch_cons_arr if uniq.
                    unless franch_cons_arr.include?(in_host_po.consolidated_term)
                        franch_cons_arr << in_host_po.consolidated_term
                    end

                    # Adds InHostPo criteria term to franch_cons_arr if uniq.
                    unless franch_cat_arr.include?(in_host_po.category)
                        franch_cat_arr << in_host_po.category
                    end
                end

                # UPDATES ATTR Core sfdc_franch_cons w item(s) from uniq_franch_cons_arr.
                franch_cons_arr.sort!
                uniq_franch_cons_arr = franch_cons_arr.uniq

                # Deletes "Non-Franchise" if it and "Group" in array, and array more than 1.
                if uniq_franch_cons_arr.length > 1 && (uniq_franch_cons_arr.include?("Group") || uniq_franch_cons_arr.include?("Non-Franchise"))
                    uniq_franch_cons_arr.delete("Non-Franchise")
                end

                # Deletes "group" in array if array more than 1.
                if uniq_franch_cons_arr.length > 1 && uniq_franch_cons_arr.include?("Group")
                    uniq_franch_cons_arr.delete("Group")
                end

                if uniq_franch_cons_arr.length > 0
                    franch_cons_result = uniq_franch_cons_arr.join(";")
                else
                    franch_cons_result = uniq_franch_cons_arr[0]
                end

                core.update_attribute(:sfdc_franch_cons, franch_cons_result)

                # UPDATES ATTR Core sfdc_franch_cat w 1-ranked-item from franch_cat_arr.
                franch_cat_arr.sort!
                uniq_franch_cat_arr = franch_cat_arr.uniq
                final_category = nil

                unless uniq_franch_cat_arr == nil
                    if uniq_franch_cat_arr.include?("Franchise")
                        final_category = "Franchise"
                    elsif uniq_franch_cat_arr.include?("Group")
                        final_category = "Group"
                    elsif uniq_franch_cat_arr.include?("Non-Franchise")
                        final_category = "Non-Franchise"
                    elsif final_category == nil || final_category == ""
                        final_category = "None"
                    else
                        final_category = "Other"
                    end
                end

                core.update_attribute(:sfdc_franch_cat, final_category)

                puts "-----------------------------------------"
                puts "Franchise Consolidator: #{counter_consolidator}"
                puts "Franchise: #{franch_cons_result}"
                puts "Category: #{final_category}"
                puts "-----------------------------------------"
                counter_consolidator +=1
            end
        end
    end

    ### FRANCHISER METHODS FOR BUTTONS - ENDS ###

    def core_data_dumper
        ### CAUTION !!! DUMPS DATA !!! ###

        # cores = Core.where(acct_source: "CRM")
        # cores.each do |core|
        #     core.update_attributes(indexer_date: nil, staffer_date: nil, whois_date: nil, staff_indexer_status: nil, location_indexer_status: nil, inventory_indexer_status: nil, staff_link: nil, staff_text: nil, location_link: nil, location_text: nil, domain_status: nil, staffer_status: nil, sfdc_template: nil)
        # end

    end


    def core_full_address_cleaner
        ## This Method Removes "Missing.." from Full Address
        ## Used to create full address from core address components.

        # cores = Core.where(full_address: nil)
        # counter = 0
        # cores.each do |core|
        #     street = core.sfdc_street
        #     city = core.sfdc_city
        #     state = core.sfdc_state
        #     zip = core.sfdc_zip
        #
        #     street == nil || street == "N/A" || street == " " || street.include?("Box") ? street = nil : street = "#{street}, "
        #     city == nil || city == "N/A" || city == " " ? city = nil : city = "#{city}, "
        #     state == nil || state == "N/A" || state == " " ? state == nil : state = "#{state}, "
        #     zip == nil || zip == "N/A" || zip == " " ? zip == nil : zip = "#{zip}, "
        #
        #     raw_full_address = "#{street}#{city}#{state}#{zip}"
        #     raw_full_address[-2] == "," ? clean_full_address = raw_full_address[0..-3] : clean_full_address = raw_full_address
        #     counter +=1
        #
        #     puts "--------------------"
        #     puts "#{counter}: #{core.sfdc_id}"
        #     puts core.sfdc_acct
        #     p core.full_address
        #     p raw_full_address
        #     p clean_full_address
        #
        #     core.update_attribute(:full_address, clean_full_address)

        # end  ## cores.each - Ends
    end


    def core_root_formatter
        ## See LocationService for another version: url_root_formatter
        ## URI gem only works on urls with http/s ##

        # cores = Core.where(sfdc_root: nil)
        # counter = 0
        # cores.each do |core|
        #
        #     unless core.sfdc_url == nil
        #         host_parts = core.sfdc_url.split(".")
        #         root = host_parts[-2]
        #         puts "------ #{counter} ---------"
        #         puts core.sfdc_url
        #         puts root
        #         counter +=1
        #
        #         core.update_attribute(:sfdc_root, root)
        #     end
        #
        # end

    end


    def period_remover
        locations = Location.where.not(geo_full_addr: nil)
        counter = 0
        locations.each do |location|
            crm_full_addy = location.address unless location.address == nil

            geo_full_addy = location.geo_full_addr unless location.geo_full_addr == nil
            street = location.street unless location.street == nil
            city = location.city unless location.city == nil
            state = location.state_code unless location.state_code == nil
            zip = location.postal_code unless location.postal_code == nil


            if street && street.include?(".")
                street_n = street.delete(".")
                street_n.strip!
            end


            if street_n

                counter +=1
                puts "------------- #{counter} -------------------"

                puts "street_o: #{street}"
                puts "street_n: #{street_n}"

                geo_full_addy_n = geo_full_addy.gsub(street, street_n)

                # location.update_attribute(:street, street_n)
                # location.update_attribute(:geo_full_addr, geo_full_addy_n)

                puts
                puts "geo_full_addy_o: #{geo_full_addy}"
                puts "geo_full_addy_n: #{geo_full_addy_n}"
                puts

            end


        end

    end


    def account_matcher
        ## Based on same url and same mailing address.

        locations = Location.where("acct_name != geo_acct_name")
        counter = 0
        locations.each do |location|
            crm_full_addy = location.address unless location.address == nil
            geo_full_addy = location.geo_full_addr unless location.geo_full_addr == nil
            crm_url = location.crm_url unless location.crm_url == nil
            geo_url = location.url unless location.url == nil
            crm_acct = location.acct_name unless location.acct_name == nil
            geo_acct = location.geo_acct_name unless location.geo_acct_name == nil

            if (crm_full_addy == geo_full_addy && crm_url == geo_url) && crm_acct != geo_acct
                counter +=1
                puts "----- #{counter} ------"
                # puts "CRM: #{crm_full_addy}"
                # puts "GEO: #{geo_full_addy}"
                # puts
                puts "CRM: #{crm_url}"
                puts "GEO: #{geo_url}"
                puts
                puts "CRM: #{crm_acct}"
                puts "GEO: #{geo_acct}"
                puts
            end







        end


    end






    def hybrid_address_matcher
        ## Combined with hybrid_address(full_address) below.
        ## Removes street name from full address.  If same, replaces CRM w/ GEO.

        locations = Location.where("address != geo_full_addr")
        counter = 1
        locations.each do |location|

                crm_full_addy = location.address unless location.address == nil
                geo_full_addy = location.geo_full_addr unless location.geo_full_addr == nil

                crm_hybrid = hybrid_address(crm_full_addy)
                geo_hybrid = hybrid_address(geo_full_addy)

                if crm_hybrid && geo_hybrid
                    if crm_hybrid == geo_hybrid
                        puts "----- #{counter} -----"
                        puts crm_full_addy
                        puts geo_full_addy
                        puts
                        # puts crm_hybrid
                        # puts geo_hybrid

                        counter +=1

                        location.update_attribute(:address, geo_full_addy)
                    end

                end


                #
                # if geo_hybrid == nil || geo_hybrid == ""

                    # geo_full_addy_arr = geo_full_addy.split(",")
                    # city_state = geo_full_addy_arr[0]
                    # city_state_arr = city_state.split(" ")
                    #
                    # city = city_state_arr[0]
                    # state = city_state_arr[1]
                    # zip = geo_full_addy_arr[2]

                    # state2 = state1 unless state1.length != 2
                    # zip2 = zip1 unless zip1.length != 5

                    # unless location.state_code == nil || location.state_code == ""
                    #     zip = location.state_code unless location.state_code.length != 5
                    #
                    #     state = location.street[-2..-1].strip
                    #     city = location.street.gsub(state, "").strip
                    #
                    #     state_upcase = state.upcase
                    #
                    #     if state == state_upcase && zip != nil && zip != ""
                    #
                    #         if crm_full_addy == nil || crm_full_addy == ""
                    #             puts "------ #{counter} ------"
                    #             puts "CRM Addy: #{crm_full_addy}"
                    #             puts "GEO Addy: #{geo_full_addy}"
                    #             new_full_addy = "#{city}, #{state}, #{zip}"
                    #             puts "New Addy: #{new_full_addy}"
                    #             counter +=1

                                # location.update_attributes(street: nil, city: city, state: state, state_code: state, postal_code: zip, geo_full_addr: new_full_addy, address: new_full_addy)
                        #     end
                        # end

                        # location.update_attributes(geo_full_addr: crm_full_addy, street: core.sfdc_street, city: core.sfdc_city, state_code: core.sfdc_state, postal_code: core.sfdc_zip)

                    # end

                # end
            # end
        end

    end


    def geo_missing_street_num
        # locations = Location.where(postal_code: nil)
        #
        # counter = 1
        # locations.each do |location|
        #     crm_root = location.crm_root unless location.crm_root == nil
        #     geo_root = location.geo_root unless location.geo_root == nil
        #     crm_full_addy = location.address unless location.address == nil
        #     geo_full_addy = location.geo_full_addr unless location.geo_full_addr == nil
        #     crm_acct = location.acct_name unless location.acct_name == nil
        #     geo_acct = location.geo_acct_name unless location.geo_acct_name == nil
        #
        #     crm_hybrid = hybrid_address(crm_full_addy)
        #     geo_hybrid = hybrid_address(geo_full_addy)
        #
        #     puts "------ #{counter} -------------"
        #     puts "CRM: #{location.acct_name}"
        #     puts "GEO: #{location.geo_acct_name}"
        #     puts "CRM: #{location.address}"
        #     puts "GEO: #{geo_full_addy}"
        #     puts "--------------------------------"
        #
        #     counter +=1
        #
        # end

    end


    def hybrid_address(full_address)
        ## Combined with above method hybrid_address_matcher

        unless full_address == nil
            address_arr = full_address.split(",")
            unless address_arr[0] == nil
                street_full = address_arr[0]
                street_num = street_full.gsub(/[^0-9]/, "")
                # street_name = street_full.gsub(/[^A-Za-z]/, "")
                # consol_addy = full_address.tr('^A-Za-z0-9', '')
                # hybrid_addy = consol_addy.gsub(street_name, "").downcase!
            end
        end
    end


    def phone_formatter
        # Formats phone numbers as: (123) 456-7899
        # cores = Core.where.not(sfdc_ph: nil)[0..10]

        # locations = Location.where.not(crm_phone: nil)
        # counter = 0
        # locations.each do |location|
        #     phone = location.crm_phone
        #
        #     if phone == "N/A" || phone == "0"
        #         phone3 = nil
        #     else
        #         phone_stripped = phone.gsub(/[^0-9]/, "")
        #
        #         if phone_stripped[0] == "1"
        #             phone2 = phone_stripped[1..-1]
        #         else
        #             phone2 = phone_stripped
        #         end
        #
        #         unless phone2.length < 10
        #             phone3 = "(#{phone2[0..2]}) #{(phone2[3..5])}-#{(phone2[6..9])}"
        #         end
        #     end
        #
        #     if phone != phone3
        #         counter +=1
        #         puts "---------------"
        #         puts counter
        #         puts "O: #{phone}"
        #         puts "N: #{phone3}"
        #         location.update_attribute(:crm_phone, phone3)
        #     end
        #
        # end
    end


    def acct_name_formatter
        ## Removes all non alpha-numberic characters
        #
        # locations = Location.all
        # counter = 1
        # locations.each do |location|
        #     geo_acct = location.geo_acct_name
        #     crm_acct = location.acct_name
        #
        #     unless geo_acct == crm_acct
        #
        #         geo_acct_cons = geo_acct.tr('^A-Za-z0-9', '').downcase
        #         crm_acct_cons = crm_acct.tr('^A-Za-z0-9', '').downcase
        #
        #         if geo_acct_cons == crm_acct_cons
        #             puts "---- #{counter} ------"
        #             puts "GEO: #{geo_acct}"
        #             puts "CRM: #{crm_acct}"
        #             puts geo_acct_cons
        #             puts crm_acct_cons
        #             puts
        #             counter +=1
        #
        #             location.update_attribute(:acct_name, geo_acct)
        #         end
        #     end
        # end
    end


    def core_acct_name_cleaner
        # If possible, use acct_name_formatter instead.  This is second option.

        # cores = Core.where("sfdc_acct LIKE '%http%'")
        # counter = 0
        # cores.each do |core|
        #     raw_acct = core.sfdc_acct
        #     raw_acct_parts = raw_acct.split('//')
        #     acct_parts = raw_acct_parts.last.split('.')
        #     useful_arr = acct_parts[0..-2]
        #     clean_acct = useful_arr.join(' ')
        #
        #     # clean_acct = raw_acct_parts[1..-2].join(' ') # google
        #     core_term = core.sfdc_franchise
        #     core_franch_cons = core.sfdc_franch_cons
        #
        #     if core_term
        #         if clean_acct.include?(core_term)
        #             clean_acct.gsub!(core_term," #{core_term} ")
        #             clean_acct.strip!
        #             final_acct = clean_acct.split.map(&:capitalize).join(' ')
        #         else
        #             final_acct = clean_acct
        #         end
        #     else
        #         final_acct = clean_acct
        #     end
        #
        #     counter +=1
        #     puts "--------------------"
        #     puts "#{counter}: #{core.sfdc_id}"
        #     puts "Raw:#{raw_acct}"
        #     puts "Clean:#{clean_acct}"
        #     puts "Final:#{final_acct}"
        #     puts "--------------------"
        #
        #     core.update_attribute(:sfdc_acct, final_acct)
        # end

    end

    def image_mover
        locations = Location.where.not(img_url: nil)
        locations.each do |location|
            cores = Core.where(sfdc_id: location.sfdc_id)
            cores.each do |core|

                if location.img_url
                    core.update_attribute(:img_url, location.img_url)
                end
            end
        end
    end


end  # Ends class CoreService  # GoogleSearchClass
