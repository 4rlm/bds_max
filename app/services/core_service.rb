require 'open-uri'
require 'mechanize'
require 'uri'
require 'date'

class CoreService
    def core_comp_cleaner_btn
        cores = Core.all

        # cores.each do |core|
        #     if core.sfdc_url == core.matched_url
        #         core.update_attribute(:url_comparison, 'Same')
        #     else
        #         core.update_attribute(:url_comparison, 'Different')
        #     end
        #
        #     if core.sfdc_root == core.matched_root
        #         core.update_attribute(:root_comparison, 'Same')
        #     else
        #         core.update_attribute(:root_comparison, 'Different')
        #     end
        # end

        cores.each do |core|
            if core.bds_status != "Matched"
                core.update_attribute(:url_comparison, nil)
                core.update_attribute(:root_comparison, nil)
            end
        end
    end

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

    def franchise_consolidator
        # cores = Core.where.not(sfdc_franchise: nil)[0..2]
        cores = Core.where.not(sfdc_franchise: nil)
        cores.each do |core|
            sfdc_terms = core.sfdc_franchise.split(';')
            criteria_consolidated_arr = []
            criteria_category_arr = []

            ## 1.) Adds Unique Consolidated Franchise Terms & Categories to Array. ##
            sfdc_terms.each do |sfdc_term|
                in_host_po = InHostPo.find_by(term: sfdc_term.downcase)
                unless criteria_consolidated_arr.include?(in_host_po.consolidated_term)
                    criteria_consolidated_arr << in_host_po.consolidated_term
                end
                unless criteria_category_arr.include?(in_host_po.category)
                    criteria_category_arr << in_host_po.category
                end
            end

            ## 2.A) Adds Consolidated Franchise Terms to Core from Array. ##
            unless criteria_consolidated_arr == nil
                criteria_consolidated_arr.each do |cons_term|
                    core.update_attribute(:sfdc_franch_cons, cons_term)
                end
            end

            ### IF Below Works, then need to create Priority list w/ if-else. ###
            ## 2.B) Adds Max 1 Franchise Category to Core from Array. ##
            unless criteria_category_arr == nil
                criteria_category_arr.each do |category|
                    core.update_attribute(:sfdc_franch_cat, category)
                end
            end


            #     unless core.sfdc_franch_cons.include?(consolidated_inhostpo)
            #         core.update_attribute(:sfdc_franch_cons, consolidated_inhostpo)
            #     end
            #
            #     unless core.sfdc_franch_cat.include?(category_inhostpo)
            #         core.update_attribute(:sfdc_franch_cat, category_inhostpo)
            #     end
            #
            # end


            # core.update_attributes(sfdc_franch_cons: consolidated_term_str, sfdc_franch_cat: category_str)


            ### Duplicate Catcher: Only update sfdc_franch_cons if uniq.
            # unless consolidated_term_str == nil && core.sfdc_franch_cons.include?(consolidated_term_str)
            #     core.update_attribute(:sfdc_franch_cons, consolidated_term_str)
            # end

            ### Duplicate Catcher: Only update sfdc_franch_cons if uniq.
            # unless category_str == nil && core.sfdc_franch_cat.include?(category_str)
            #     core.update_attribute(:sfdc_franch_cat, category_str)
            # end

            #### After testing above, create if else to rank "Franchise as top cat term." ####
            #### Then, add duplicate catcher in franchise_termer for terms. ####
        end
    end

    def franchise_termer

        ## Step1: DELETES FRANCHISE DATA IN CORES
        # cores = Core.all[0..1]
        # cores = Core.all
        # cores.each {|core| core.update_attributes(sfdc_franchise: nil, sfdc_franch_cons: nil, sfdc_franch_cat: nil)}

        # Loop Entire Core through Each Franchise Term Row. ##
        brands = InHostPo.all[0..1]
        brands.each do |brand|
            sfdc_cores = Core.where("sfdc_acct LIKE '%#{brand.term}%' OR  sfdc_acct LIKE '%#{brand.term.capitalize}%' OR sfdc_root LIKE '%#{brand.term}%' OR sfdc_root LIKE '%#{brand.term.capitalize}%'")
            sfdc_cores.each do |core|

                # unless core.sfdc_franchise == nil && core.sfdc_franchise.include?(brand.term.capitalize)

                prev_brand = core.sfdc_franchise ? core.sfdc_franchise + ";" : ""
                core.update_attribute(:sfdc_franchise, prev_brand + brand.term.capitalize)
            end
        end

    end

    # def franchise_btn
    #     brands = InHostPo.all
    #     brands = InHostPo.where("term in ('group', 'buick')")
    #
    #     brands.each do |brand|
    #         cores = Core.where("sfdc_acct LIKE '%#{brand.term}%' OR  sfdc_acct LIKE '%#{brand.term.capitalize}%' OR sfdc_root LIKE '%#{brand.term}%' OR sfdc_root LIKE '%#{brand.term.capitalize}%'")[0..1]
    #
    #         cores.each do |core|
    #             core.update_attributes(sfdc_franch_cons: "", sfdc_franch_cat: "")
    #
    #             if core.sfdc_franch_cons.include?(brand.consolidated_term)
    #                 str1 = core.sfdc_franch_cons
    #             else
    #                 str1 = core.sfdc_franch_cons << brand.consolidated_term + ';'
    #             end
    #
    #             if core.sfdc_franch_cat.include?(brand.category)
    #                 category_str = core.sfdc_franch_cat
    #             else
    #                 category_str = core.sfdc_franch_cat << brand.category
    #             end
    #
    #             if category_str.include?('franchise')
    #                 str2 = 'franchise'
    #             elsif category_str.include?('group')
    #                 str2 = 'group'
    #             elsif category_str.include?('non-franchise')
    #                 str2 = 'non-franchise'
    #             else
    #                 str2 = 'other'
    #             end
    #
    #             core.update_attributes(sfdc_franch_cons: str1.split(';').map(&:capitalize).join(';'), sfdc_franch_cat: str2.capitalize)
    #         end
    #
    #     end
    # end

    ### FRANCHISER METHODS FOR BUTTONS - ENDS ###


    def col_splitter
        cores = Core.where.not(matched_url: nil)

        cores.each do |core|
            Core.create(temporary_id: core.sfdc_id, bds_status: core.bds_status, sfdc_acct: (core.site_acct ||core.matched_url), sfdc_street: core.site_street, sfdc_city: core.site_city, sfdc_state: core.site_state, sfdc_zip: core.site_zip, sfdc_ph: core.site_ph, sfdc_url: core.matched_url, sfdc_root: core.matched_root, created_at: core.domainer_date, core_date: core.domainer_date, indexer_date: core.indexer_date, staffer_date: core.staffer_date, staff_indexer_status: core.staff_indexer_status, location_indexer_status: core.location_indexer_status, staff_link: core.staff_link, staff_text: core.staff_text, location_link: core.location_link, location_text: core.location_text, domain_status: core.domain_status, staffer_status: core.staffer_status, acct_source: "Web", sfdc_geo_addy: core.site_geo_addy, sfdc_lat: core.site_lat, sfdc_lon: core.site_lon, sfdc_geo_status: core.site_geo_status, sfdc_geo_date: core.site_geo_date, sfdc_coordinates: core.site_coordinates, sfdc_template: core.site_template, url_status: "Valid", sfdc_id: "web#{DateTime.now.strftime('%Q')}")
        end
    end

end  # Ends class CoreService  # GoogleSearchClass
