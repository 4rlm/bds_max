class UnknownTemplate
    def initialize
        @manager = RtsManager.new
    end

    def meta_scraper(html, url, indexer)
        puts "\n\nIndexer ID: #{indexer.id}\nURL: #{url}\n\n"
        all_text = html.at_css('body').text

        # Get phones and title directly
        phones = @manager.rts_phones_finder(html) # Scrape all the phone numbers.
        title = html.at_css('head title').text

        # Get state and zip
        state_zip_reg = Regexp.new("([A-Z]{2})[ ]?([0-9]{5})")
        state_zip_match_data = state_zip_reg.match(all_text) #<MatchData "MI 48302" 1:"MI" 2:"48302">
        state_zip = state_zip_match_data[0] # "MI 48302"
        state = state_zip_match_data[1] # "MI"
        zip = state_zip_match_data[2] # "48302"

        # Get combined street & city
        addr_reg = Regexp.new("(\\w+\.+\\n?\.+)#{state_zip}")
        addr_reg_match_data = addr_reg.match(all_text) #<MatchData "1234 Nice Rd. \r\n    Phoenix, AZ 88302" 1:"1234 Nice Rd. \r\n    Phoenix, ">
        full_addr_raw = addr_reg_match_data[0] # "1234 Nice Rd. \r\n    Phoenix, AZ 88302"
        street_city = addr_reg_match_data[1] # "1234 Nice Rd. \r\n    Phoenix, "

        # # Below Regex needs more logic. Not used yet.
        # street = street_city.match(/[\w.]+/).to_s # Grab only character and '.' except \t,\n,\r
        # city = street_city.split(street)[-1].match(/[\w.]+/).to_s

        result = {title: title, full_addr_raw: full_addr_raw, street_city: street_city, state: state, zip: zip, phones: phones}
        puts "\nTitle: #{title}\nStreetCity: #{street_city}\nState: #{state}\nZip: #{zip}\nPhones: #{phones}\nFullAddrRaw: #{full_addr_raw}\n#{"-"*40}\n"
        update_indexer(result, indexer)
    end

    def update_indexer(result, indexer)
        indexer.update_attributes(indexer_status: "Meta Result", acct_name: result[:title], rt_sts: "Meta Result", raw_addr: result[:full_addr_raw], raw_street: result[:street_city], full_addr: "Meta Result", street: "Meta Result", city: "Meta Result", state: result[:state], zip: result[:zip], phone: result[:phones][0], phones: result[:phones])
    end
end
