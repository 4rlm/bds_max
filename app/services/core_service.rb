require 'open-uri'
require 'mechanize'
require 'uri'

class CoreService  # GoogleSearchClass
    def initialize
        @agent = Mechanize.new
    end

    # == Core Method starts here.===================|*|
    def scrape_listing(ids)  # search
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
                state_st = state
            end

            # ----- Encoding Begins -----------------------------------------
            url = "http://www.google.com/search?"
            num = "&num=1000"
            client = "&client=google-csbe"
            key = "&cx=016494735141549134606:xzyw78w1vn0"
            tag1 = "&as_oq=auto+automobile+car+cars+vehicle+vehicles"
            tag2 = "&as_oq=dealer+dealership+group"

            q_combinded = "q=#{acct_q}#{street_q}#{city_q}#{state_st}"
            acct_req = "&as_epq=#{acct_gs}"
            acct_opt = "&oq=#{acct_gs}"

            url_encoded = "#{url}#{q_combinded}#{num}#{client}#{key}"
            #=== End - Encoded Search =====================

            # == Loop (1): through each encoded search url. ======
            @agent.get(url_encoded) do |page|
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
                        exclude = []
                        ExcludeRoot.all.map(&:term).each do |term|
                            exclude << term if root == term
                        end
                        exclude_root = exclude.empty? ? '(blank)' : exclude.join('; ')
                        #============================

                        #== CSV Filter: 2_in_suffix_del
                        suffix_del = []
                        InSuffixDel.all.map(&:term).each do |term|
                            suffix_del << term if suffix == term
                        end
                        in_suffix_del = suffix_del.empty? ? '(blank)' : suffix_del.join('; ')
                        #============================

                        #== CSV Filter: 3_in_host_del
                        host_del = []
                        InHostDel.all.map(&:term).each do |term|
                            host_del << term if hostc.include?(term)
                        end
                        in_host_del = host_del.empty? ? '(blank)' : host_del.join('; ')
                        #============================

                        #== CSV Filter: 4_in_host_neg
                        host_neg = []
                        InHostNeg.all.map(&:term).each do |term|
                            host_neg << term if hostc.include?(term)
                        end
                        in_host_neg = host_neg.empty? ? '(blank)' : host_neg.join('; ')
                        #============================

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

                        #== CSV Filter: 7_in_text_neg
                        text_neg = []
                        InTextNeg.all.map(&:term).each do |term|
                            text_neg << term if text.include?(term)
                        end
                        in_text_neg = text_neg.empty? ? '(blank)' : text_neg.join('; ')
                        #============================

                        #== CSV Filter: 8_in_text_pos
                        text_pos = []
                        InTextPo.all.map(&:term).each do |term|
                            text_pos << term if text.include?(term)
                        end
                        in_text_pos = text_pos.empty? ? '(blank)' : text_pos.join('; ')
                        #============================

                        # === TESTING: ROOT COUNTER (BOTTOM) ===
                        root_count_array << root
                        root_counter = root_count_array.count(root)
                        # === END - TESTING: ROOT COUNTER (BOTTOM) ===

                        # Create new Gsce objects
                        add_data_row(current_time, search_query_num, url_export_num, id, ult_acct, acct, type, street, city, state, url_o, sfdc_root, root, domain, root_counter, suffix, in_host_pos, in_host_neg, in_host_del, in_suffix_del, exclude_root, text, in_text_pos, in_text_neg, in_text_del, url_encoded)

                    end # Ends: if uri.class.to_s
                end # Ends: page.links.each
            end # Ends: agent.get(url_encoded)

            #==== Update Core Object ========================
            # el is from Core.where(id: ids)
            # Update "domainer_date" column of the queued Core objects.
            el.update_attributes(domainer_date: current_time, bds_status: "Dom Result")
        end # Ends Core.all.each
    end # Ends scrape_listing  # search

    # "root_counter" variable will be added later after adding root_counter column.
    def add_data_row(datetime, search_query_num, url_export_num, id, ult_acct, acct, type, street, city, state, url_o, sfdc_root, root, domain, root_counter, suffix, in_host_pos, in_host_neg, in_host_del, in_suffix_del, exclude_root, text, in_text_pos, in_text_neg, in_text_del, url_encoded)
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
            in_host_neg: in_host_neg,
            in_host_del: in_host_del,
            in_suffix_del: in_suffix_del,
            exclude_root: exclude_root,
            text: text,
            in_text_pos: in_text_pos,
            in_text_neg: in_text_neg,
            in_text_del: in_text_del,
            url_encoded: url_encoded
        )
        gcse.save
    end  # Ends add_data_row

end  # Ends class CoreService  # GoogleSearchClass