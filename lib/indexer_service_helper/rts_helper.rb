# Helper Method for CobaltRts
class RtsHelper
    # PARSES OUT THE ADDRESS FROM:  html.at_css('.dealer-info').text when address contains "\n"
    def addr_parser(str)
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

    # Parse full address into org, street, city, state, zip, phone.
    def addr_processor(full_addr)
        states, zips, phones = [], [], []

        if !full_addr.blank?
            addr_arr = rts_validator(full_addr)
            unless addr_arr.blank?
                # Sends Each Result Item to Check for Phone, State and Zip
                addr_arr.each do |item|
                    phones << item if !item.blank?
                    # state_zip = state_zip_get(item) if !state_zip_get(item).blank? # not working

                    # if state_zip # not working
                    #     states << state_zip[0..1] if !state_zip[0..1].blank? ## state
                    #     zips << state_zip[-5..-1] if !state_zip[-5..-1].blank? ## zip
                    # end

                    if item.include?(" ") && item.split(" ").length == 2
                        splits = item.split(" ")
                        states.concat(splits)
                        zips.concat(splits)
                    else
                        states << item
                        zips << item
                    end
                end
                street = addr_arr[0]
                city = addr_arr[1]
            end
        end
        {street: street, city: city, states: states, zips: zips, phones: phones}
    end

    # Helper method for `addr_processor(full_addr)` and `org_processor(orgs)`
    def rts_validator(obj)
        objs = []
        ### Removes "\t" from objects.
        ### Then splits objects by "\n".
        unless obj.blank?
            if obj.include?("\n")
                objs = obj.split("\n")
                objs = objs.join(",")
            end

            if obj.include?("|")
                objs = obj.split("|")
                objs = objs.join(",")
            end

            if obj.include?(",")
                objs = obj
            end

            regex = Regexp.new("[a-z][\.]?[A-Z][a-z]")
            if regex.match(obj)
                objs = obj.gsub(/([a-z])[.]?([A-Z][a-z])/,'\1,\2')
            end

            objs = objs.is_a?(String) ? objs.split(",") : [obj]

            negs = ["hours", "contact", "location", "map", "info", "directions", "used", "click", "proudly", "serves", "twitter", "geoplaces", "youtube", "facebook", "privacy", "choices", "window", "event", "listener", "contact", "function", "department", "featured", "vehicle", "customer", "today"]

            negs.each do |neg|
                objs.delete_if { |x| x.downcase.include?(neg) }
            end

            objs.map!{|obj| obj.strip}
            objs.delete_if {|x| x.blank?}
            objs = objs.uniq
        end
        objs
    end

    def org_processor(orgs)
        result = []
        orgs.each do |org|
            result.concat(rts_validator(org))
        end
        result
    end

    def org_addr_divider(org_n_addr)
        return {} if org_n_addr.nil?
        splits = org_n_addr.split("\n")
        parts = splits.map(&:strip).delete_if {|x| x.blank?}

        {org: parts.delete_at(0), addr: parts.join(',')}
    end

    # Validate org, street, city, state, zip, phone individually.
    def final_arr_qualifier(array, option)
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

    # Helper method for `final_arr_qualifier(array, option)`
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

    # ================== NOT USED ==================
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
end
