class UnknownTemplate
    def initialize
        @manager = RtsManager.new
    end

    def meta_scraper(html, url, indexer)
        all_text = html.at_css('body').text

        # Get phones and title directly
        phones = @manager.rts_phones_finder(html) # Scrape all the phone numbers.
        title = html.at_css('head title').text

        # Get state and zip (eg. AZ 81234)
        state_zip_reg = Regexp.new("[A-Z]{2}[ ]?[0-9]{5}")
        state_zip = state_zip_reg.match(all_text).to_s

        # Get raw full address (e.g. 1234 Nice Rd. \r\n    Phoenix, AZ 81234)
        addr_reg = Regexp.new("\\w+\.+\\n?\.+#{state_zip}")
        full_addr_raw = addr_reg.match(all_text).to_s

        # Get each parts of full address
        state = state_zip.match(/[A-Z]{2}/).to_s
        zip = state_zip.match(/[0-9]{5}/).to_s

        street_city = full_addr_raw.split(state_zip)[0]
        # street = street_city.match(/[\w.]+/).to_s # Grab only character and '.' except \t,\n,\r
        # city = street_city.split(street)[-1].match(/[\w.]+/).to_s

        result = {title: title, full_addr_raw: full_addr_raw, street_city: street_city, state: state, zip: zip, phones: phones}

        puts "\n\nIndexer ID: #{indexer.id}\nURL: #{url}\n\n"
        update_indexer(result, indexer)
    end

    def update_indexer(result, indexer)
        indexer.update_attributes(indexer_status: "Meta Result", acct_name: result[:title], rt_sts: "Meta Result", raw_addr: result[:full_addr_raw], raw_street: result[:street_city], full_addr: "Meta Result", street: "Meta Result", city: "Meta Result", state: result[:state], zip: result[:zip], phone: result[:phones][0], phones: result[:phones])
    end
end