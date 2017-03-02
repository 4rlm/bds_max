require 'open-uri'
require 'mechanize'
require 'uri'
require 'nokogiri'
require 'socket'
require 'pry'
require 'httparty'
require 'dealerfire_rts'


class IndexerService

    ###########################################
    ###  SCRAPER METHODS: rooftop_data_getter ~ STARTS
    ###########################################

    def rooftop_data_getter
        a=20
        z=30
        # a=500
        # z=1000
        # a=1000
        # z=-1
        # indexers = Indexer.where(template: "DealerOn").where(rt_sts: nil).where.not(clean_url: nil)[a...z]  ##852
        # indexers = Indexer.where(template: "Dealer.com")[a...z]
        # indexers = Indexer.where(template: "Cobalt")[a...z]

        # indexers = Indexer.where(rt_sts: "TCP Error").where.not(clean_url: nil)[a...z]
        # indexers = Indexer.where(template: "Cobalt").where(rt_sts: nil).where.not(clean_url: nil)[a...z]
        # indexers = Indexer.where(template: "Dealer Inspire").where(rt_sts: nil).where.not(clean_url: nil)[a...z]

        indexers = Indexer.where(template: "Cobalt").where.not(rt_sts: "RT Result").where.not(clean_url: nil)[a...z] #1206
        # indexers = Indexer.where(clean_url: "http://www.woodmotornissan.com")

        # indexers = Indexer.where(template: "DealerFire").where(rt_sts: nil).where.not(clean_url: nil)[a...z]


        counter=0
        range = z-a
        indexers.each do |indexer|
            template = indexer.template
            clean_url = indexer.clean_url
            template == "Cobalt" ? url = "#{clean_url}/HoursAndDirections" : url = clean_url
            method = IndexerTerm.where(response_term: template).where.not(mth_name: nil).first
            term = method.mth_name

            counter+=1
            puts "\n============================\n"
            puts "[#{a}...#{z}]  (#{counter}/#{range})"

            # begin
                @agent = Mechanize.new
                html = @agent.get(url)

                case term
                when "dealer_com_rts"
                    dealer_com_rts(html, url, indexer)
                when "dealeron_rts"
                    dealeron_rts(html, url, indexer)
                when "cobalt_rts"
                    cobalt_rts(html, url, indexer)
                when "dealer_inspire_rts"
                    dealer_inspire_rts(html, url, indexer)
                when "dealerfire_rts"
                    dealerfire_rts(html, url, indexer)
                end

            # rescue
                # error = $!.message
                # error_msg = "RT Error: #{error}"
                # if error_msg.include?("connection refused")
                #     rt_error_code = "Connection Error"
                # elsif error_msg.include?("undefined method")
                #     rt_error_code = "Method Error"
                # elsif error_msg.include?("404 => Net::HTTPNotFound")
                #     rt_error_code = "404 Error"
                # elsif error_msg.include?("TCP connection")
                #     rt_error_code = "TCP Error"
                # else
                #     rt_error_code = error_msg
                # end
                # puts "\n\n>>> #{error_msg} <<<\n\n"

                # indexer.update_attributes(indexer_status: "RT Error", rt_sts: rt_error_code)
            # end ## rescue ends

            sleep(3)
        end ## .each loop ends

    end


    ##### DEALER FIRE RTS CORE METHOD BEGINS ~ ########
    def dealerfire_rts(html, url, indexer)
        result = DealerfireRts.rooftop_scraper(html)
        rt_address_formatter(result[:org], result[:street], result[:city], result[:state], result[:zip], result[:phone], url, indexer)
    end
    ##### DEALER FIRE RTS CORE METHOD ENDS ~ #########


    ##### DEALER INSPIRE RTS CORE METHOD BEGINS ~ ######
    def dealer_inspire_rts(html, url, indexer)
        org = html.at_css('.organization-name').text if html.at_css('.organization-name')
        acc_phones = html.css('.tel').collect {|phone| phone.text if phone} if html.css('.tel')
        phone = acc_phones.join(', ')

        street = html.at_css('.street-address').text if html.at_css('.street-address')

        if street && street.include?(",")
            street = street.split(",")
            street = street[0]
            if street.include?("  ")
                street = street.split(" ")
                street = street.join(" ")
            end
            street.strip!
        end

        city = html.at_css('.locality').text if html.at_css('.locality').text
        state = html.at_css('.region').text if html.at_css('.region').text
        zip = html.at_css('.postal-code').text if html.at_css('.postal-code').text

        rt_address_formatter(org, street, city, state, zip, phone, url, indexer)
    end
    ##### DEALER INSPIRE RTS CORE METHOD ENDS ~ ######


    ##### COBALT RTS CORE METHOD BEGINS ~ ##########
    def cobalt_rts(html, url, indexer)
        orgs = []
        streets = []
        cities = []
        states = []
        zips = []
        phones = []

        ### OUTLYER: Special format, so doesn't follow same process as others below.
        ### === FULL ADDRESS AND ORG VARIABLE ===
        addr_n_org1 = html.at_css('.dealer-info').text if html.at_css('.dealer-info')
        if !addr_n_org1.blank?
            addr_arr = cobalt_addr_parser(addr_n_org1)
            city_state_zip = addr_arr[2]
            city_state_zip_arr = city_state_zip.split(",")
            state_zip = city_state_zip_arr[1]
            state_zip_arr = state_zip.split(" ")
            orgs << addr_arr[0]
            streets << addr_arr[1]
            cities << city_state_zip_arr[0]
            states << state_zip_arr[0]
            zips << state_zip_arr[-1]
        end

        ### === PHONE VARIABLES ===
        phone1 = html.css('.contactUsInfo').text if html.css('.contactUsInfo')
        phone2 = html.at_css('.dealerphones_masthead').text if html.at_css('.dealerphones_masthead')
        phone3 = html.at_css('.dealerTitle').text if html.at_css('.dealerTitle')
        phones << phone1 if !phone1.blank?
        phones << phone2 if !phone2.blank?
        phones << phone3 if !phone3.blank?

        ### === ORG VARIABLES ===
        org1 = html.at_css('.dealerNameInfo').text if html.at_css('.dealerNameInfo')
        org2_sel = "//img[@class='cblt-lazy']/@alt"
        org2 = html.xpath(org2_sel)
        orgs << org1 if !org1.blank?
        orgs << org2 if !org1.blank?

        ### === ADDRESS VARIABLES ===
        # addr1 = html.at_css('.addressText').text if html.at_css('.addressText')
        addr2_sel = "//a[@href='HoursAndDirections']"
        addr2 = html.xpath(addr2_sel).text if html.xpath(addr2_sel)
        addr3 = html.at_css('.dealerAddressInfo').text if html.at_css('.dealerAddressInfo')
        addr_n_ph1 = html.at_css('.dealerDetailInfo').text if html.at_css('.dealerDetailInfo')
        cobalt_addr_processor(addr2, orgs, streets, cities, states, zips, phones)
        cobalt_addr_processor(addr3, orgs, streets, cities, states, zips, phones)
        cobalt_addr_processor(addr_n_ph1, orgs, streets, cities, states, zips, phones)

        ### Methods to Process above Data
        # org = cobalt_final_arr_qualifier(orgs, org)
        # street = cobalt_final_arr_qualifier(streets, street)
        # city = cobalt_final_arr_qualifier(cities, city)
        # state = cobalt_final_arr_qualifier(states, state)
        # zip = cobalt_final_arr_qualifier(zips, zip)
        # phone = cobalt_final_arr_qualifier(phones, phone)

        ### Methods to Process above Data
        org = cobalt_final_arr_qualifier(orgs, org)
        street = cobalt_final_arr_qualifier(streets, street)
        city = cobalt_final_arr_qualifier(cities, city)
        state = cobalt_final_arr_qualifier(states, state)
        zip = cobalt_final_arr_qualifier(zips, zip)
        phone = cobalt_final_arr_qualifier(phones, phone)

        street = street_qualifier(street) if !street.nil?
        city = city_qualifier(city) if !city.nil?
        zip = zip_qualifier(zip) if !zip.nil?

        # org = org_qualifier(org)
        state = state_qualifier(state) if !state.nil?

        rt_address_formatter(org, street, city, state, zip, phone, url, indexer)
    end
    ##### COBALT RTS CORE METHOD ENDS ~ ##########
    ###### COBALT RTS HELPER METHODS ENDS ~ #######


    def state_qualifier(state)
        st = state if !state.nil?
        alpha = st.tr('^A-Za-z', '')
        digits = st.tr('^0-9', '')
        (digits != '' || alpha == '' || alpha.length != 2) ? state = nil : state
    end

    def street_qualifier(street)
        st = street if !street.nil?
        alpha = st.tr('^A-Za-z', '')
        digits = st.tr('^0-9', '')
        (digits == '' || alpha == '' || alpha.length == 2) ? street = nil : street
    end

    def city_qualifier(city)
        cit = city if !city.nil?
        alpha = cit.tr('^A-Za-z', '')
        digits = cit.tr('^0-9', '')
        (alpha.nil? || alpha.length == 2 || digits != "") ? city = nil : city
    end

    def zip_qualifier(zip)
        zp = zip if !zip.nil?
        alpha = zp.tr('^A-Za-z', '')
        digits = zp.tr('^0-9', '')
        (digits == '' || digits.length != 5 || alpha != '') ? zip = nil : zip
    end


    def cobalt_final_arr_qualifier(array, cat)
        if !array.blank? && cat.blank?
            array.each do |item|
                cat = item if !item.blank?
                if cat
                    break
                end
            end
        end
        cat
    end

    ### === FULL ADDRESS METHOD ===
    def cobalt_addr_processor(full_addr, orgs, streets, cities, states, zips, phones)
        if !full_addr.blank?
            addr_arr = n_splitter(full_addr)
            unless addr_arr.blank?
                # Sends Each Result Item to Check for Phone
                addr_arr.each do |item|
                    phones << item if !item.blank?
                end

                # Sends each Results Item to Check for State and Zip
                addr_arr.each do |item|
                    state_zip = state_zip_get(item) if !state_zip_get(item).blank?

                    if state_zip
                        states << state_zip[0..1] if !state_zip[0..1].blank? ## state
                        zips << state_zip[-5..-1] if !state_zip[-5..-1].blank? ## zip
                    end
                end

                # Sends Street to Street Array and City to City Array.
                streets << addr_arr[0] if !addr_arr[0].blank? ## street
                cities << addr_arr[1] if !addr_arr[1].blank? ## city
            end
        end
    end

    def n_splitter(obj)
        ### Removes "\t" from objects.
        ### Then splits objects by "\n".
        unless obj.blank?
            obj.include?("\n") ? objs = obj.split("\n") : objs = obj.split(",")
            objs = objs.join(",")
            objs = objs.split(",")
            objs.delete_if {|x| x.include?("Hours")}
            objs.delete_if {|x| x.include?("Contact")}
            objs.delete_if {|x| x.include?("Location")}
            objs.delete_if {|x| x.include?("Map")}
            objs.delete_if {|x| x.include?("Info")}
            objs.delete_if {|x| x.include?("Directions")}
            objs.map!{|obj| obj.strip!}
            objs.delete_if {|x| x.blank?}
        end
    end

    def state_zip_get(item)
        ## Detects and parses zip and state from string, without affecting original string.
        if !item.nil?
            smash = item.gsub(" ", "")
            smash.strip!
            alphanum = smash.tr('^A-Z0-9', '')

            if alphanum.length == 7 && smash == alphanum
                state_test = alphanum.tr('^A-Z', '')
                zip_test = alphanum.tr('^0-9', '')

                if state_test.length == 2 && zip_test.length == 5
                    state = state_test
                    zip = zip_test
                    item = state+zip
                else
                    item = nil
                end
            end
        end
    end

    def cobalt_addr_parser(str)
        ### PARSES OUT THE ADDRESS FROM:  html.at_css('.dealer-info').text when address contains "\n"
        str.strip!
        parts = str.split("   ")
        parts.each do |s|
            if s == "" || s == "\n"
                parts.delete(s)
            else
                s.strip!
            end
        end

        for x in ["\n", ""]
            parts.delete(x) if parts.include?(x)
        end
        parts # returns array
    end
    ###### COBALT RTS HELPER METHODS END ~ ########


    ##### DEALERON RTS CORE METHOD BEGINS ~ #######
    def dealeron_rts(html, url, indexer)
        acc_phones = html.css('.callNowClass').collect {|phone| phone.text if phone}
        raw_full_addr = html.at_css('.adr').text if html.at_css('.adr')
        full_addr_arr = raw_full_addr.split(",") if raw_full_addr
        zip_state_arr = full_addr_arr[-1].split(" ")

        org = html.at_css('.dealerName').text if html.at_css('.dealerName')
        street = full_addr_arr[-3] if full_addr_arr
        city = full_addr_arr[-2] if full_addr_arr
        state = zip_state_arr[-2] if zip_state_arr
        zip = zip_state_arr[-1] if zip_state_arr
        phone = acc_phones[0]
        ### MOVED FROM rt_address_formatter B/C DESIGNED ONLY FOR DO TEMP.
        if (city && street == nil) && city.include?("\r")
            street_city_arr = city.split("\r")
            street = street_city_arr[0] unless street_city_arr[0] == nil
            city = street_city_arr[-1] unless street_city_arr[-1] == nil
        end

        rt_address_formatter(org, street, city, state, zip, phone, url, indexer)
    end
    ##### DEALERON RTS CORE METHOD ENDS ~ #######


    ##### DEALER.COM RTS CORE METHOD BEGINS ~ #######
    def dealer_com_rts(html, url, indexer)
        selector = "//meta[@name='author']/@content"
        org = html.xpath(selector).text if html.xpath(selector)
        street = html.at_css('.adr .street-address').text if html.at_css('.adr .street-address')
        city = html.at_css('.adr .locality').text if html.at_css('.adr .locality')
        state = html.at_css('.adr .region').text if html.at_css('.adr .region')
        zip = html.at_css('.adr .postal-code').text if html.at_css('.adr .postal-code')
        phone = html.at_css('.value').text if html.at_css('.value')
        rt_address_formatter(org, street, city, state, zip, phone, url, indexer)
    end
    ##### DEALER.COM RTS CORE METHOD ENDS ~ #######



    ###############################################
    ### RTS PROCESSING METHODS ~ BEGIN (ALL TEMPLATES USE THESE!!!)
    ###############################################
    def rt_address_formatter(org, street, city, state, zip, phone, url, indexer)
        ### USED FOR ALL TEMPLATES
        ### STRIPS AND FORMATS DATA BEFORE SAVING TO DB

        org = nil if org.blank?
        street = nil if org.blank?
        city = nil if org.blank?
        state = nil if org.blank?
        zip = nil if org.blank?
        phone = nil if org.blank?

        org.strip! if org
        street.strip! if street
        city.strip! if city
        state.strip! if state
        zip.strip! if zip

        if zip && state && zip.length < 5 && state > 2
            temp_zip = state
            temp_state = zip
            zip = temp_zip
            state = temp_state
        end

        full_addr_street = "#{street}, " if street
        full_addr_city = "#{city}, " if city
        full_addr_state = "#{state}, " if state
        full_addr_zip = "#{zip}" if zip
        full_addr = "#{full_addr_street}#{full_addr_city}#{full_addr_state}#{full_addr_zip}"
        full_addr.strip!

        if full_addr && full_addr[-1] == ","
            full_addr = full_addr[0...-1]
            full_addr.strip!
        end

        if full_addr && full_addr[0] == ","
            full_addr = full_addr[1..-1]
            full_addr.strip!
        end

        full_addr = nil if full_addr.blank?  || full_addr == ","

        rt_results_processor(org, street, city, state, zip, phone, full_addr, url, indexer)
    end


    def ph_check(string)
        ### USED FOR ALL TEMPLATES - STRICT QUALIFICATIONS!!!!!
        ### FORMATS PHONE AS: (000) 000-0000
        if !string.blank? && string != "N/A" && string != "0" && (string.include?("(") || string.include?("-"))
            if string[0] == "0" || string[0] == "1"
                stripped = string[1..-1]
            else
                stripped = string
            end

            # smash = stripped.gsub(/[^A-Za-z0-9]/, "")
            digits = stripped.tr('^0-9', '')
            # if smash == digits && digits.length == 10
            if digits.length == 10
                phone = "(#{digits[0..2]}) #{(digits[3..5])}-#{(digits[6..9])}"
            else
                phone = nil
            end
        else
            phone = nil
        end
    end


    def phone_formatter(phone)
        ### USED FOR ALL TEMPLATES  - LOOSE QUALIFICATIONS!!!!!
        ### FORMATS PHONE AS: (000) 000-0000
        if !phone.blank? && (phone != "N/A" || phone != "0")
            phone_stripped = phone.gsub(/[^0-9]/, "")
            (phone_stripped && phone_stripped[0] == "1") ? phone_step2 = phone_stripped[1..-1] : phone_step2 = phone_stripped

            !(phone_step2 && phone_step2.length < 10) ? final_phone = "(#{phone_step2[0..2]}) #{(phone_step2[3..5])}-#{(phone_step2[6..9])}" : final_phone = phone

            final_phone
        else
            final_phone = nil
            final_phone
        end

    end


    def rt_results_processor(org, street, city, state, zip, phone, full_addr, url, indexer)
        ### USED FOR ALL TEMPLATES
        if org || street || city || state || zip || phone || full_addr
            phone = phone_formatter(phone)

            puts indexer.template
            puts "#{url} \n\nRT Result - Success!\n\n"
            org.nil? ? (puts "org: nil") : (p "org: #{org}")
            phone.nil? ? (puts "phone: nil") : (p "phone: #{phone}")
            street.nil? ? (puts "street: nil") : (p "street: #{street}")
            city.nil? ? (puts "city: nil") : (p "city: #{city}")
            state.nil? ? (puts "state: nil") : (p "state: #{state}")
            zip.nil? ? (puts "zip: nil") : (p "zip: #{zip}")
            full_addr.nil? ? (puts "full_addr: nil") : (p "full_addr: #{full_addr}")

            # indexer.update_attributes(indexer_status: "RT Result", acct_name: org, rt_sts: "RT Result", full_addr: full_addr, street: street, city: city, state: state, zip: zip, phone: phone)
        else
            puts "#{url} \n\nRT No-Result - Check Template Version!\n\n"
            # indexer.update_attributes(indexer_status: "RT No-Result", acct_name: org, rt_sts: "RT No-Result")
        end

        puts "\n============================\n\n"

    end


    ###### RT HELPER METHODS ~ ENDS #######

    ###########################################
    ###  SCRAPER METHODS: rooftop_data_getter ~ ENDS
    ###########################################





    ###########################################
    ###  MAIN INDEXER METHODS: rooftop_data_getter ~ BEGINS
    ###########################################

    def indexer_starter
        # a=0
        # z=1800
        # a=1800
        # z=3600
        a=3600
        z=-1

        els = Indexer.where(stf_status: "SFDC URL").where.not(template: "Search Error").where.not(template: "Unidentified")[a...z] ##6669

        @agent = Mechanize.new
        @agent.follow_meta_refresh = true

        locations_text_list = IndexerTerm.where(sub_category: "loc_text").where(criteria_term: "general").map(&:response_term)
        locations_href_list = to_regexp(IndexerTerm.where(sub_category: "loc_href").where(criteria_term: "general").map(&:response_term))
        staff_text_list = IndexerTerm.where(sub_category: "staff_text").where(criteria_term: "general").map(&:response_term)
        staff_href_list = to_regexp(IndexerTerm.where(sub_category: "staff_href").where(criteria_term: "general").map(&:response_term))

        counter=0
        els.each do |el|
            @indexer = el
            template = el.template

            counter+=1
            puts "[#{a}...#{z}]  (#{counter}):  #{template}"

            redirect_status = el.redirect_status
            if redirect_status == "Same" || redirect_status == "Updated"

                begin
                    url = el[:clean_url]

                    begin
                        page = @agent.get(url)
                    rescue Mechanize::ResponseCodeError => e
                        redirect_url = HTTParty.get(url).request.last_uri.to_s
                        page = @agent.get(redirect_url)
                    end

                    puts "\n----------------------------------------\n"
                    puts url

                    page_finder(locations_text_list, locations_href_list, url, page, "location")
                    page_finder(staff_text_list, staff_href_list, url, page, "staff")

                rescue
                    error_msg = "Error: #{$!.message}"
                    status = nil
                    indexer_status = nil
                    found = false

                    indexer_terms = IndexerTerm.where(category: "url_redirect").where(sub_category: "error_msg")
                    indexer_terms.each do |term|
                        if error_msg.include?(term.criteria_term)
                            status = term.response_term
                            found = true
                        else
                            status = error_msg
                        end

                        indexer_status = status == "TCP Error" ? status : "Indexer Error"
                        break if found
                    end # indexer_terms iteration ends

                    indexer_status = "Indexer Error" unless found
                    el.update_attributes(indexer_status: indexer_status, stf_status: status, staff_url: error_msg, loc_status: status, location_url: error_msg)
                end # rescue ends
                sleep(1)
            end
        end # Ends cores Loop
    end # Ends start_indexer(ids)


    def page_finder(text_list, href_list, url, page, mode)
        for text in text_list
            if pages = page.link_with(:text => text)
                url_split_joiner(url, pages, mode)
                break
            end
        end

        if !pages
            for href in href_list
                if pages = page.link_with(:href => href)
                    url_split_joiner(url, pages, mode)
                    break
                end
            end

            if !pages
                add_indexer_row_with("No Matches", nil, nil, nil, mode)
            end
        end
    end # Ends page_finder


    def url_split_joiner(url, pages, mode)
        url_s = url.split('/')
        url_http = url_s[0]
        url_www = url_s[2]
        joined_url = validater(url_http, '//', url_www, pages.href)
        add_indexer_row_with("Matched", pages.text.strip, pages.href, joined_url, mode)
    end


    def add_indexer_row_with(status, text, href, link, mode)
        if mode == "location"
            puts "#{status}: #{text}"
            @indexer.update_attributes(indexer_status: "Indexer Result", loc_status: status, location_url: link, location_text: text) if @indexer != nil
            puts link
            puts text
            puts "----------------------------------------"
        elsif mode == "staff"
            puts "#{status}: #{text}"
            @indexer.update_attributes(indexer_status: "Indexer Result", stf_status: status, staff_url: link, staff_text: text) if @indexer != nil
            puts link
            puts text
            puts "----------------------------------------"
        end
    end


    def validater(url_http, dbl_slash, url_www, dirty_url)
        if dirty_url.include?(url_http + dbl_slash)
            dirty_url
        else
            url_http + dbl_slash + url_www + dirty_url
        end
    end


    def to_regexp(arr)
        arr.map {|str| Regexp.new(str)}
    end

    #####################
    ### indexer_starter Ends
    #####################


    ####################
    # TEMPLATE DETECTOR - STARTS
    ####################

    def template_finder
        # a=200
        # z=2000
        # a=2000
        # z=4000
        a=4000
        z=6000

        # indexers = Indexer.where(template: "SFDC URL").where.not(clean_url: nil)[a...z] #1348
        indexers = Indexer.where(template: "Unidentified").where.not(clean_url: nil)[a...z] #8047
        # indexers = Indexer.where(template: "Search Error").where(stf_status: "Matched")[a..z] #138
        # indexers = Indexer.where(template: "Dealer Inspire")[a..z]

        counter=0
        indexers.each do |indexer|
            url = indexer.clean_url
            db_template = indexer.template
            criteria_term = nil
            template = nil
            counter+=1

            begin
                @agent = Mechanize.new
                doc = @agent.get(url)

                indexer_terms = IndexerTerm.where(category: "template_finder").where(sub_category: "at_css")
                indexer_terms.each do |indexer_term|
                    criteria_term = indexer_term.criteria_term
                    if doc.at_css('html').text.include?(criteria_term)
                        template = indexer_term.response_term

                        if template
                            puts
                            puts "[#{a}...#{z}]  (#{counter})   Success!"
                            puts url
                            puts "Term: #{criteria_term}"
                            puts "Temp: #{template}"
                            puts "DB: #{db_template}"
                        indexer.update_attribute(:template, template)
                        else
                            puts
                            puts "[#{a}...#{z}]  (#{counter})   Unidentified"
                            puts url
                            puts "Term: #{criteria_term}"
                            puts "Temp: #{template}"
                            puts "DB: #{db_template}"
                        indexer.update_attribute(:template, template)
                        end

                        break
                    end
                end

            rescue
                puts
                puts "[#{a}...#{z}]  (#{counter})   Search Error"
                puts url
                puts "Term: #{criteria_term}"
                puts "Temp: #{template}"
                puts "DB: #{db_template}"
                indexer.update_attribute(:template, "Search Error")
            end

            sleep(1)

        end
    end

    ####################
    # TEMPLATE DETECTOR - Ends
    ####################

    ####################
    # URL Redirect Checker - Starts
    ####################

    def url_redirect_checker
        require 'curb'
        # indexers = Indexer.where.not(crm_url: nil).where.not(crm_url: "").where("url != crm_url").where(crm_url_redirect: nil)
        # indexers = Indexer.where.not(crm_url: nil).where.not(crm_url: "").where("url != crm_url").where(geo_url_redirect: nil)[20...-1]
        # indexers = Indexer.where(redirect_status: nil).where(stf_status: "SFDC URL").where(indexer_status: "SFDC URL").where("raw_url LIKE '%http%'")[a...z]
        # indexers = Indexer.where(redirect_status: nil).where(stf_status: "SFDC URL").where(indexer_status: "SFDC URL").where("raw_url LIKE '%www%'")[a...z]
        # indexers = Indexer.where(redirect_status: nil).where(stf_status: "SFDC URL").where(indexer_status: "SFDC URL").where.not("raw_url LIKE '%www%'")[a...z]
        # Indexer.where.not("redirect_status LIKE '%Error%'")

        a=200
        z=-1
        # a=350
        # z=-1
        # a=2600
        # z2-1
        # 2630

        indexers = Indexer.where(clean_url: nil).where(redirect_status: nil)[a...z]

        counter_fail = 0
        counter_result = 0
        total = 0
        indexers.each do |indexer|
            total +=1

            raw_url = indexer.raw_url

            begin ## rescue
                result = Curl::Easy.perform(raw_url) do |curl|
                    curl.follow_location = true
                    curl.useragent = "curb"
                    curl.connect_timeout = 10
                    curl.enable_cookies = true
                    # curl.ssl_verify_peer = false
                end

                curb_url_result = result.last_effective_url

                crm_url_hash = url_formatter(curb_url_result)
                raw_url_final = crm_url_hash[:new_url]

                if raw_url != raw_url_final
                    counter_result +=1
                    puts
                    puts "[#{a}...#{z}] (#{counter_result}/#{total})"
                    puts "O: #{raw_url}"
                    puts "N: #{raw_url_final}"
                    puts "--------------------------------------------"
                    puts
                    indexer.update_attributes(redirect_status: "Updated", clean_url: raw_url_final)
                else
                    puts "[#{a}...#{z}] (#{total}): Same"
                    indexer.update_attributes(redirect_status: "Same", clean_url: raw_url_final)
                end

            rescue  #begin rescue
                error_message = $!.message
                counter_fail +=1
                final_error_msg = "Error: #{error_message}"
                puts "(#{counter_fail}/#{total})  (#{final_error_msg})"

                if final_error_msg && final_error_msg.include?("Error:")
                    if final_error_msg.include?("SSL connect error")
                        indexer.update_attributes(indexer_status: "Redirect Error", redirect_status: "SSL Error")
                    elsif final_error_msg.include?("Couldn't resolve host name")
                        indexer.update_attributes(indexer_status: "Redirect Error", redirect_status: "Host Error")
                    elsif final_error_msg.include?("Peer certificate")
                        indexer.update_attributes(indexer_status: "Redirect Error", redirect_status: "Certificate Error")
                    elsif final_error_msg.include?("Failure when receiving data")
                        indexer.update_attributes(indexer_status: "Redirect Error", redirect_status: "Transfer Error")
                    else
                        indexer.update_attributes(indexer_status: "Redirect Error", redirect_status: "Error")
                    end
                end
            end  #end rescue
        end
    end

    ####################
    # URL Redirect Checker - Ends
    ####################



#####################



    def staff_url_cleaner
        # indexers = Indexer.where(template: "Search Error").where("staff_url LIKE '%.comstaff%'")
        indexers = Indexer.where(template: "Search Error").where(staff_url: nil)
        counter=0
        indexers.each do |indexer|
            staff_url = indexer.staff_url

            counter+=1
            puts "#{counter}) #{staff_url}"
            # new_staff_url = staff_url.gsub(".comstaff", ".com/staff")
            # puts new_staff_url
            puts
            # indexer.update_attributes(template: nil, staff_url: new_staff_url)
            indexer.update_attribute(:template, nil)
        end
    end


    def dup_url_cleaner
        bigs = Indexer.where.not(raw_url: nil)
        big_counter=0
        small_counter=0
        if bigs
            bigs.each do |big|
                big_raw_url = big.raw_url
                big_id = big.id

                pre_count = Indexer.where(raw_url: big_raw_url).count
                big_counter+=1
                puts
                puts "#{big_counter}) #{big_raw_url}"
                puts "pre_count: #{pre_count}"

                smalls = Indexer.where(raw_url: big_raw_url).where.not(id: big_id)
                smalls.each do |small|
                    small_raw_url = small.raw_url
                    small_id = small.id

                    small_counter+=1
                    puts "------------------ #{small_counter} ------------------ "
                    puts
                    puts "big_raw_url: #{big_raw_url}"
                    puts "small_raw_url: #{small_raw_url}"
                    puts "big_id: #{big_id}"
                    puts "small_id: #{small_id}"

                    small.destroy
                end

                post_count = Indexer.where(raw_url: big_raw_url).count
                puts "post_count: #{post_count}"
                puts
            end
        end
    end

    def url_downcase
        a=0
        z=-1
        indexers = Indexer.where.not(raw_url: nil)[a..z]
        counter=0
        indexers.each do |indexer|
            raw_url = indexer.raw_url
            down_raw_url = raw_url.downcase if raw_url
            counter+=1
            unless raw_url == down_raw_url
                puts
                puts "[#{a}...#{z}] (#{counter}) #{raw_url} / #{down_raw_url}"
                puts
                indexer.update_attribute(:raw_url, down_raw_url)
            end
        end
    end


    def hyrell_cleaner
        indexers = Indexer.where("raw_url LIKE '%.hyrell.%'")
        indexers.each do |indexer|
            raw_url = indexer.raw_url
            if raw_url.include?(".hyrell")
                puts
                new_raw_url = raw_url.gsub(".hyrell.", ".")
                puts raw_url
                puts new_raw_url
                indexer.update_attributes(raw_url: new_raw_url, redirect_status: nil)
            end
        end
    end


    def pending_verifications_importer
        pens = PendingVerification.all
        counter=0
        target_counter=0

        puts "\n\n======================================\n\n"

        pens.each do |pen|
            pen_url = pen.domain

            pen_url[-1] == "/" ? pen_url = pen_url[0...-1] : pen_url

            counter+=1
            raw_url = Indexer.exists?(raw_url: pen_url)
            clean_url = Indexer.exists?(clean_url: pen_url)

            if raw_url || clean_url
                puts "#{counter}/X) #{pen_url}"
            else
                target_counter+=1
                puts "#{counter}/#{target_counter})     IMPORTING: #{pen_url}"

                Indexer.create(raw_url: pen_url, indexer_status: "SFDC URL", stf_status: "SFDC URL", loc_status: "SFDC URL", template: "SFDC URL")
            end

        end

        puts "\n\n======================================\n\n"

    end


    def count_contacts
        indexers = Indexer.where.not(clean_url: nil).where(contacts_count: nil)
        counter=0
        indexers.each do |indexer|
            clean_url = indexer.clean_url
            contacts_count = Staffer.where(domain: clean_url).count

            counter+=1
            puts "---------------------- #{counter} ----------------------"
            puts clean_url
            puts contacts_count
            puts
            indexer.update_attribute(:contacts_count, contacts_count)
        end
    end


    def reset_errors
        # indexers = Indexer.where(stf_status: "Error")[0..100]
        # indexers = Indexer.where("staff_url LIKE '%TCP connection%'")
        # indexers = Indexer.where(indexer_status: "Indexer Error")
        indexers = Indexer.all

        counter=0
        indexers.each do |indexer|
            puts
            counter+=1
            puts "Cleaning Record: #{counter} ....."

            indexer_status = indexer.indexer_status

            stf_status = indexer.stf_status
            staff_text = indexer.staff_text
            staff_url = indexer.staff_url

            loc_status = indexer.loc_status
            location_text = indexer.location_text
            location_url = indexer.location_url

            raw_url = indexer.raw_url
            clean_url = indexer.clean_url
            redirect_status = indexer.redirect_status


            if staff_text && staff_text.length > 35
                new_staff_text = staff_text[0..35]
                indexer.update_attribute(:staff_text, new_staff_text)
            end

            if location_text && location_text.length > 35
                new_location_text = location_text[0..35]
                indexer.update_attribute(:location_text, new_location_text)
            end

            if loc_status && loc_status == "Re-Queue"
                indexer.update_attribute(:loc_status, nil)
            end

            if stf_status && stf_status == "Re-Queue"
                indexer.update_attribute(:stf_status, nil)
            end

            if stf_status && (stf_status == "Matched" || stf_status == "No Matches") || loc_status && (loc_status == "Matched" || loc_status == "No Matches") && indexer_status != "Indexer Result"
                indexer.update_attribute(:indexer_status, "Indexer Result")
            end

            if redirect_status && redirect_status.include?("Error:")
                if redirect_status.include?("SSL connect error")
                    indexer.update_attributes(indexer_status: "Redirect Error", redirect_status: "SSL Error")
                elsif redirect_status.include?("Couldn't resolve host name")
                    indexer.update_attributes(indexer_status: "Redirect Error", redirect_status: "Host Error")
                elsif redirect_status.include?("Peer certificate")
                    indexer.update_attributes(indexer_status: "Redirect Error", redirect_status: "Certificate Error")
                elsif redirect_status.include?("Failure when receiving data")
                    indexer.update_attributes(indexer_status: "Redirect Error", redirect_status: "Transfer Error")
                elsif redirect_status.include?("Errno::ECONNRESET")
                    indexer.update_attributes(indexer_status: "Redirect Error", redirect_status: "Reset Error")
                elsif redirect_status.include?("Errno::ECONNRESET")
                    indexer.update_attributes(indexer_status: "504 => Net::HTTPGatewayTimeOut", redirect_status: "504 Error")
                else
                    indexer.update_attributes(indexer_status: "Redirect Error", redirect_status: "Error")
                end
            end

            if raw_url && clean_url
                if raw_url == clean_url
                    indexer.update_attribute(:redirect_status, "Same")
                else
                    indexer.update_attribute(:redirect_status, "Updated")
                end
            elsif raw_url == nil || clean_url == nil
                indexer.update_attribute(:redirect_status, nil)
            end

            if (staff_url && staff_url.include?("TCP connection")) || (location_url && location_url.include?("TCP connection"))
                status = "TCP Error"
                indexer.update_attributes(indexer_status: status, loc_status: status, stf_status: status, staff_text: nil, location_text: nil)
            elsif (staff_url && staff_url.include?("403 => Net::HTTPForbidden")) || (location_url && location_url.include?("403 => Net::HTTPForbidden"))
                status = "403 Error"
                indexer.update_attributes(indexer_status: "Indexer Error", loc_status: status, stf_status: status, staff_text: nil, location_text: nil)
            elsif (staff_url && staff_url.include?("410 => Net::HTTPGone")) || (location_url && location_url.include?("410 => Net::HTTPGone"))
                status = "410 Error"
                indexer.update_attributes(indexer_status: "Indexer Error", loc_status: status, stf_status: status, staff_text: nil, location_text: nil)
            elsif (staff_url && staff_url.include?("500 => Net::HTTPInternalServerError")) || (location_url && location_url.include?("500 => Net::HTTPInternalServerError"))
                status = "500 Error"
                indexer.update_attributes(indexer_status: "Indexer Error", loc_status: status, stf_status: status, staff_text: nil, location_text: nil)
            elsif (staff_url && staff_url.include?("SSL_connect returned")) || (location_url && location_url.include?("500 => Net::HTTPInternalServerError"))
                status = "SSL Error"
                indexer.update_attributes(indexer_status: "Indexer Error", loc_status: status, stf_status: status, staff_text: nil, location_text: nil)
            elsif (staff_url && staff_url.include?("404 => Net::HTTPNotFound")) || (location_url && location_url.include?("404 => Net::HTTPNotFound"))
                status = "404 Error"
                indexer.update_attributes(indexer_status: "Indexer Error", loc_status: status, stf_status: status, staff_text: nil, location_text: nil)
            elsif (staff_url && staff_url.include?("400 => Net::HTTPBadRequest")) || (location_url && location_url.include?("400 => Net::HTTPBadRequest"))
                status = "400 Error"
                indexer.update_attributes(indexer_status: "Indexer Error", loc_status: status, stf_status: status, staff_text: nil, location_text: nil)
            elsif (staff_url && staff_url.include?("nil:NilClass")) || (location_url && location_url.include?("nil:NilClass"))
                status = "Nil Error"
                indexer.update_attributes(indexer_status: "Indexer Error", loc_status: status, stf_status: status, staff_text: nil, location_text: nil)
            elsif (staff_url && staff_url.include?("undefined method")) || (location_url && location_url.include?("undefined method"))
                status = "Method Error"
                indexer.update_attributes(indexer_status: "Indexer Error", loc_status: status, stf_status: status, staff_text: nil, location_text: nil)
            elsif (staff_url && staff_url.include?("undefined method")) || (location_url && location_url.include?("503 => Net::HTTPServiceUnavailable"))
                status = "503 Error"
                indexer.update_attributes(indexer_status: "Indexer Error", loc_status: status, stf_status: status, staff_text: nil, location_text: nil)
            end
        end
    end


    def scraped_contacts_sts_checker
        indexers = Indexer.where.not(staff_text: nil).where(contact_status: nil).where.not(clean_url: nil)

        counter=0
        indexers.each do |indexer|
            clean_url = indexer.clean_url
            indexer_template = indexer.template
            contact_status = indexer.contact_status

            contacts = Staffer.where(domain: clean_url)[0..0]
            contacts.each do |contact|

                unless contact_status
                    staffer_status = contact.staffer_status
                    cont_status = contact.cont_status
                    staff_link = contact.staff_link
                    domain = contact.domain
                    staffer_template = contact.template

                    if domain == clean_url && contact_status == nil
                        counter+=1
                        puts
                        puts "------------------ #{counter} ------------------"
                        puts staffer_status
                        puts cont_status
                        puts staff_link
                        puts domain
                        puts staffer_template
                        puts

                        indexer.update_attributes(contact_status: "Scraped", template: staffer_template)
                    end
                end
            end
        end
    end


    def url_arr_extractor
        # locs = Location.where.not(url: nil).where.not(sts_duplicate: "URL Check")[0..-1]
        locs = Location.where.not(crm_url_redirect: nil)[0..-1]
        num=0
        print "#{num}, "

        loc_count=0
        indexer_count=0
        puts
        locs.each do |loc|
            loc_count+=1
            url_arr = loc.url_arr
            crm_url = loc.crm_url
            geo_url = loc.url
            crm_url_redirect = loc.crm_url_redirect
            geo_url_redirect = loc.geo_url_redirect

            exists = Indexer.exists?(raw_url: geo_url_redirect)

            if exists == false
                indexer_count+=1
                puts
                puts "(#{indexer_count}/#{loc_count}) Adding: #{geo_url_redirect}"
                loc.update_attribute(:sts_duplicate, "URL Check")
                Indexer.create(raw_url: geo_url_redirect)
            end
        end
        puts
    end


    def url_importer
        locs = Location.where.not(url: nil)
        counter=0
        locs.each do |loc|
            puts "#{counter}) #{loc.url}"
            Indexer.create(raw_url: loc.url)
        end
    end


    def url_formatter(url)
        unless url == nil || url == ""
            url.gsub!(/\P{ASCII}/, '')
            url = remove_slashes(url)
            if url.include?("\\")
                url_arr = url.split("\\")
                url = url_arr[0]
            end
            unless url.include?("www.")
                url = url.gsub!("//", "//www.")
            else
                url
            end

            uri = URI(url)
            new_url = "#{uri.scheme}://#{uri.host}"

            if uri.host
                host_parts = uri.host.split(".")
                new_root = host_parts[1]
            end
            return {new_url: new_url, new_root: new_root}
        end
    end


    def remove_slashes(url)
        # For rare cases w/ urls with mistaken double slash twice.
        parts = url.split('//')
        if parts.length > 2
            return parts[0..1].join
        end
        url
    end


    def template_counter
        indexer_terms = IndexerTerm.where(sub_category: "at_css").where.not(response_term: nil)
        indexer_terms.each do |term|
            template = term.response_term
            temp_count = Indexer.where(template: template).count

            puts "#{template}: #{temp_count}"

            term.update_attribute(:response_count, temp_count)

        end

    end




end # IndexerService class Ends ---
