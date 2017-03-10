class UnknownTemplate
    def initialize
        @manager = RtsManager.new
    end

    def meta_scraper(html, url, indexer)
        all_text = html.at_css('body').text

        # Get phones and title directly
        phones = @manager.rts_phones_finder(html) # Scrape all the phone numbers.
        title = html.at_css('head title').text

        # trial_title = rts_validator(title)
        # puts "trial_title: #{trial_title}\n^^^^"

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

        puts "\nTitle: #{title}\nStreet: #{street_city}\nState: #{state}\nZip: #{zip}\nPhones: #{phones}\nAddr: #{full_addr_raw}\n#{"-"*40}\n"


        update_indexer(result, indexer)
    end

    def update_indexer(result, indexer)
        indexer.update_attributes(indexer_status: "Meta Result", acct_name: result[:title], rt_sts: "Meta Result", raw_addr: result[:full_addr_raw], raw_street: result[:street_city], full_addr: "Meta Result", street: "Meta Result", city: "Meta Result", state: result[:state], zip: result[:zip], phone: result[:phones][0], phones: result[:phones])
    end



    #
    # def rts_validator(obj)
    #     objs = []
    #     unless obj.blank?
    #         obj = filter(obj, "\n")
    #         obj = filter(obj, "|")
    #         obj = filter(obj, "\t")
    #         obj = filter(obj, ",")
    #
    #         # Separate address. eg. Nice Rd.CityName
    #         regex = Regexp.new("[a-z][\.]?[A-Z][a-z]")
    #         if regex.match(obj)
    #             obj = obj.gsub(/([a-z])[.]?([A-Z][a-z])/,'\1,\2')
    #         end
    #
    #         objs = obj.split(",")
    #
    #         negs = ["hours", "contact", "location", "map", "info", "directions", "used", "click", "proudly", "serves", "twitter", "geoplaces", "youtube", "facebook", "privacy", "choices", "window", "event", "listener", "contact", "function", "department", "featured", "vehicle", "customer", "today"]
    #         negs.each do |neg|
    #             objs.delete_if { |x| x.downcase.include?(neg) }
    #         end
    #
    #         objs.map!{|obj| obj.strip}
    #         objs.delete_if {|x| x.blank?}
    #         objs = objs.uniq
    #     end
    #     objs
    # end


    # def filter(str, bad)
    #     if str.include?(bad)
    #         objs = str.split(bad)
    #         objs.delete_if {|x| x.blank?}
    #         objs = objs.uniq
    #         str = objs.map(&:strip).join(",")
    #     end
    #     str
    # end





end
