class CobaltRts
    def rooftop_scraper(html)
        orgs, streets, cities, states, zips, phones = [], [], [], [], [], []

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

        # binding.pry

        ### === PHONE VARIABLES ===
        phones.concat(html.css('.contactUsInfo').map(&:children).map(&:text)) if html.css('.contactUsInfo').any?
        phones << html.at_css('.dealerphones_masthead').text if html.at_css('.dealerphones_masthead')
        phones << html.at_css('.dealerTitle').text if html.at_css('.dealerTitle')
        phones << html.at_css('.cta .insight').text if html.at_css('.cta .insight')
        phones << html.at_css('.dealer-ctn').text if html.at_css('.dealer-ctn')

        ### === ORG VARIABLES ===
        orgs << html.at_css('.dealerNameInfo').text if html.at_css('.dealerNameInfo')
        orgs.concat(html.xpath("//img[@class='cblt-lazy']/@alt").map(&:value))
        orgs << html.at_css('.dealer .insight').text if html.at_css('.dealer .insight')
        orgs.concat(html.css('.card .title').map(&:children).map(&:text)) if html.css('.card .title').any?

        ### === ADDRESS VARIABLES ===
        addr2_sel = "//a[@href='HoursAndDirections']"
        addr2 = html.xpath(addr2_sel).text if html.xpath(addr2_sel)
        addr3 = html.at_css('.dealerAddressInfo').text if html.at_css('.dealerAddressInfo')
        addr_n_ph1 = html.at_css('.dealerDetailInfo').text if html.at_css('.dealerDetailInfo')
        addr4 = html.at_css('address').text if html.at_css('address')
        addr4 = html.at_css('address').text if html.at_css('address')
        addr5 = html.css('.card .content .text .copy span').map(&:children).map(&:text).join(', ') if html.css('.card .content .text .copy span')

        puts "\n>>>>>>>>>>\n orgs: #{orgs}, addr_n_org1: #{addr_n_org1}, phones: #{phones}\n>>>>>>>>>>\n"

        result_1 = cobalt_addr_processor(addr2)
        result_2 = cobalt_addr_processor(addr3)
        result_3 = cobalt_addr_processor(addr_n_ph1)
        result_4 = cobalt_addr_processor(addr4)
        result_5 = cobalt_addr_processor(addr5)

        streets.concat([ result_1[:street], result_2[:street], result_3[:street], result_4[:street], result_5[:street] ]) # [string, string ...]
        cities.concat([ result_1[:city], result_2[:city], result_3[:city], result_4[:city], result_5[:city] ]) # [string, string ...]
        states.concat(result_1[:states] + result_2[:states] + result_3[:states] + result_4[:states] + result_5[:states]) # arrary + array + ....
        zips.concat(result_1[:zips] + result_2[:zips] + result_3[:zips] + result_4[:zips] + result_5[:zips]) # arrary + array + ....
        phones.concat(result_1[:phones] + result_2[:phones] + result_3[:phones] + result_4[:phones] + result_5[:phones]) # arrary + array + ....

        ### Call Methods to Process above Data
        org = cobalt_final_arr_qualifier(orgs, "org")
        street = cobalt_final_arr_qualifier(streets, "street")
        city = cobalt_final_arr_qualifier(cities, "city")
        state = cobalt_final_arr_qualifier(states, "state")
        zip = cobalt_final_arr_qualifier(zips, "zip")
        phone = cobalt_final_arr_qualifier(phones, "phone")

        {org: org, street: street, city: city, state: state, zip: zip, phone: phone}
    end

    # ==================== HELPER ==================== #
    def org_qualifier(org, negs)
        return if org.nil?
        alpha = org.tr('^A-Za-z', '')
        digits = org.tr('^0-9', '')
        smash = alpha+digits
        selected = negs.select {|neg| org.downcase.include?(neg) }

        (alpha == '' || alpha.length < 6) || (smash.length == 7 && digits.length == 5) || (selected.any?) ? nil : org
    end

    def street_qualifier(street, negs)
        return if street.nil?
        alpha = street.tr('^A-Za-z', '')
        digits = street.tr('^0-9', '')
        selected = negs.select {|neg| street.downcase.include?(neg) }

        (digits == '' || alpha == '' || alpha.length == 2) || (selected.any?) ? nil : street
    end

    def city_qualifier(city, negs)
        return if city.nil?
        alpha = city.tr('^A-Za-z', '')
        digits = city.tr('^0-9', '')
        selected = negs.select {|neg| city.downcase.include?(neg) }

        (alpha.nil? || alpha.length == 2 || digits != "") || (selected.any?) ? nil : city
    end

    def state_qualifier(state, negs)
        return if state.nil?
        alpha = state.tr('^A-Za-z', '')
        digits = state.tr('^0-9', '')
        selected = negs.select {|neg| state.downcase.include?(neg) }

        (digits != '' || alpha == '' || alpha.length != 2) || (selected.any?) ? nil : state
    end

    def zip_qualifier(zip, negs)
        return if zip.nil?
        alpha = zip.tr('^A-Za-z', '')
        digits = zip.tr('^0-9', '')
        selected = negs.select {|neg| zip.downcase.include?(neg) }

        (digits == '' || digits.length != 5 || alpha != '') || (selected.any?) ? nil : zip
    end


    def cobalt_final_arr_qualifier(array, option)
        return if array.empty?
        negs = ["contact", "link", "click", "map", "(", "-", "location", "savings"]
        result = nil

        array.each do |el|
            if !el.blank?
                result = org_qualifier(el, negs) if option == "org"
                result = street_qualifier(el, negs) if option == "street"
                result = city_qualifier(el, negs) if option == "city"
                result = state_qualifier(el, negs) if option == "state"
                result = zip_qualifier(el, negs) if option == "zip"
                result = IndexerService.new.phone_formatter(el) if option == "phone"
                break if result
            end
        end
        result
    end

    ### === FULL ADDRESS METHOD ===
    def cobalt_addr_processor(full_addr)
        states, zips, phones = [], [], []

        if !full_addr.blank?
            addr_arr = n_splitter(full_addr)
            unless addr_arr.blank?
                # Sends Each Result Item to Check for Phone, State and Zip
                addr_arr.each do |item|
                    phones << item if !item.blank?
                    # state_zip = state_zip_get(item) if !state_zip_get(item).blank? # not working

                    # if state_zip # not working
                    #     states << state_zip[0..1] if !state_zip[0..1].blank? ## state
                    #     zips << state_zip[-5..-1] if !state_zip[-5..-1].blank? ## zip
                    # end
                    states << item
                    zips << item
                end
                street = addr_arr[0]
                city = addr_arr[1]
            end
        end
        {street: street, city: city, states: states, zips: zips, phones: phones}
    end

    def n_splitter(obj)
        ### Removes "\t" from objects.
        ### Then splits objects by "\n".
        unless obj.blank?
            # obj.include?("\n") ? objs = obj.split("\n") : objs = obj.split(",")

            if obj.include?("\n")
                objs = obj.split("\n")
                objs = objs.join(",")
            end

            if obj.include?("|")
                objs = obj.split("|")
                objs = objs.join(",")
            end

            objs = objs.split(",")

            negs = ["hours", "contact", "location", "map", "info", "directions", "used", "Click", "proudly", "serves", "twitter", "geoplaces", "youtube", "facebook", "privacy", "choices", "window", "event", "listener", "contact", "function", "department", "featured", "vehicle", "customer", "today"]

            ## Need to Downcase temporarily before running through negs.

            # objs.delete_if {|x| x.include?("hours")}
            # objs.delete_if {|x| x.include?("contact")}
            # objs.delete_if {|x| x.include?("location")}
            # objs.delete_if {|x| x.include?("map")}
            # objs.delete_if {|x| x.include?("info")}
            # objs.delete_if {|x| x.include?("directions")}
            # objs.delete_if {|x| x.include?("used")}
            # objs.delete_if {|x| x.include?("Click")}
            # objs.delete_if {|x| x.include?("proudly")}
            # objs.delete_if {|x| x.include?("serves")}
            # objs.delete_if {|x| x.include?("twitter")}
            # objs.delete_if {|x| x.include?("geoplaces")}
            # objs.delete_if {|x| x.include?("youtube")}
            # objs.delete_if {|x| x.include?("facebook")}
            # objs.delete_if {|x| x.include?("privacy")}
            # objs.delete_if {|x| x.include?("choices")}
            # objs.delete_if {|x| x.include?("window")}
            # objs.delete_if {|x| x.include?("event")}
            # objs.delete_if {|x| x.include?("listener")}
            # objs.delete_if {|x| x.include?("contact")}
            # objs.delete_if {|x| x.include?("function")}
            # objs.delete_if {|x| x.include?("department")}
            # objs.delete_if {|x| x.include?("featured")}
            # objs.delete_if {|x| x.include?("vehicle")}
            # objs.delete_if {|x| x.include?("customer")}
            # objs.delete_if {|x| x.include?("today")}

            objs.map!{|obj| obj.strip!}
            objs.delete_if {|x| x.blank?}

            objs.uniq!
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
        item
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
end
