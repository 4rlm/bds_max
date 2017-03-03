class CobaltRts
    def rooftop_scraper(html)
        orgs, streets, cities, states, zips, phones = [], [], [], [], [], []

        ### OUTLYER: Special format, so doesn't follow same process as others below.
        ### === FULL ADDRESS AND ORG VARIABLE ===
        addr_n_org1 = html.at_css('.dealer-info').text if html.at_css('.dealer-info')
        return {} if addr_n_org1.blank?

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

        ### === PHONE VARIABLES ===
        phones << html.css('.contactUsInfo').text if html.css('.contactUsInfo')
        phones << html.at_css('.dealerphones_masthead').text if html.at_css('.dealerphones_masthead')
        phones << html.at_css('.dealerTitle').text if html.at_css('.dealerTitle')

        ### === ORG VARIABLES ===
        orgs << html.at_css('.dealerNameInfo').text if html.at_css('.dealerNameInfo')
        orgs.concat(html.xpath("//img[@class='cblt-lazy']/@alt").map(&:value))

        ### === ADDRESS VARIABLES ===
        addr2_sel = "//a[@href='HoursAndDirections']"
        addr2 = html.xpath(addr2_sel).text if html.xpath(addr2_sel)
        addr3 = html.at_css('.dealerAddressInfo').text if html.at_css('.dealerAddressInfo')
        addr_n_ph1 = html.at_css('.dealerDetailInfo').text if html.at_css('.dealerDetailInfo')

        result_1 = cobalt_addr_processor(addr2)
        result_2 = cobalt_addr_processor(addr3)
        result_3 = cobalt_addr_processor(addr_n_ph1)

        streets.concat([ result_1[:street], result_2[:street], result_3[:street] ])
        cities.concat([ result_1[:city], result_2[:city], result_3[:city] ])
        states.concat(result_1[:states] + result_2[:states] + result_3[:states])
        zips.concat(result_1[:zips] + result_2[:zips] + result_3[:zips])
        phones.concat(result_1[:phones] + result_2[:phones] + result_3[:phones])

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
                result = IndexerService.new.ph_check(el) if option == "phone"
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
                    state_zip = state_zip_get(item) if !state_zip_get(item).blank?

                    if state_zip
                        states << state_zip[0..1] if !state_zip[0..1].blank? ## state
                        zips << state_zip[-5..-1] if !state_zip[-5..-1].blank? ## zip
                    end
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
end
