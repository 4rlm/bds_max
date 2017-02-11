class LocationService

    def geo_places_starter
        ## ORIGINAL IS BASED ON "CORES".  THIS IS BASED ON "LOCATIONS".

        ## TEMPORARY - FOR RE-RUNNING WRONG ACCOUNT NAME RESULTS
        locations = Location.where(crm_source: "Web").where("geo_acct_name != acct_name").where("address != geo_full_addr").where.not(location_status: "Re-Run Failed").where.not(location_status: "Spots: Empty")[1..-1]

        # locations = Location.where(crm_source: "Web").where("geo_acct_name != acct_name").where(location_status: "Spots: Empty")[2..5]

        counter = 0
        locations.each do |location|
            counter += 1
            puts
            puts "=========== #{counter} ==========="
            puts
            # puts "----- GEO (original) -----"
            # puts "Name: #{location.geo_acct_name}"
            # puts "Addr: #{location.geo_full_addr}"
            # puts "URL: #{location.url}"
            # puts
            # puts
            # puts "----- CRM (original) -----"
            # puts "Name: #{location.acct_name}"
            # puts "Addr: #{location.address}"
            # puts "URL: #{location.crm_url}"

            get_spot(location)
        end

        ## GETS LOCATIONS WITHOUT IMAGE
        # locations = Location.where(img_url: nil).where.not(postal_code: nil).where.not(location_status: "IMG Search")[30000..-1]
        # counter = 0
        # locations.each do |location|
        #     counter += 1
        #     puts "----- #{counter} -------"
        #     get_spot(location)
        # end


    end


    # def get_spot(core)
    def get_spot(location)
        client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])

        # if location.address != nil
        #     custom_query = "#{location.acct_name} near #{location.address}"
        # else
        #     custom_query = location.acct_name
        # end

        crm_url = location.crm_url

        if crm_url != nil && crm_url != ""

            uri = URI(crm_url)
            host = uri.host

            if host.include?("www.")
                short_host = host.gsub("www.", "")
            else
                short_host = host
            end

            # custom_query = "#{location.crm_url}"
            spots = client.spots_by_query(short_host, types: ["car_dealer"])
        elsif location.acct_name != nil
            custom_query = location.acct_name
            spots = client.spots_by_query(custom_query, types: ["car_dealer"])
        else
            puts "Re-Run Failed"
            location.update_attribute(:location_status, "Re-Run Failed")
            return
        end


        if spots.empty?
            # core.update_attributes(bds_status: "Geo Error", geo_status: "Geo Error", geo_date: Time.new)
            puts "Spots: Empty"
            # location.update_attribute(:location_status, "IMG Search")
            location.update_attribute(:location_status, "Spots: Empty")
            return
        else
            spot = spots.first
            detail = client.spot(spot.reference)
            create_geo_place(location, spot, detail)
        end
    end

    def create_geo_place(location, spot, detail)
        # puts
        # puts "----- GEO (new) -----"
        # puts "Name: #{spot.name}"

        formatted_address = detail.formatted_address
        if formatted_address.include?(", United States")

            new_formatted_address = formatted_address.gsub(", United States", "").strip
            new_formatted_address_arr = new_formatted_address.split(",")

            street = new_formatted_address_arr[0].strip
            street.include?("Street") ? street.gsub!("Street", "St") : street
            street.include?("Avenue") ? street.gsub!("Avenue", "Ave") : street
            street.include?("Highway") ? street.gsub!("Highway", "Hwy") : street
            street.include?("Boulevard") ? street.gsub!("Boulevard", "Blvd") : street
            street.include?("Road") ? street.gsub!("Road", "Rd") : street
            street.include?("Drive") ? street.gsub!("Drive", "Dr") : street
            street.include?("Lane") ? street.gsub!("Lane", "Ln") : street

            city = new_formatted_address_arr[-2].strip
            state_zip_arr = new_formatted_address_arr[-1].split(" ")
            state = state_zip_arr[0]
            zip = state_zip_arr[1]

            unless street == city || city == state || state == zip
                street != nil || street != "" ? street_if = "#{street}, " : street_if = nil
                city != nil || city != "" ? city_if = "#{city}, " : city_if = nil
                state != nil || state != "" ? state_if = "#{state}, " : state_if = nil
                new_full_address = street_if+city_if+state_if+zip
                # puts "Addr: #{new_full_address}"
            else
                new_full_address = "Error: Duplicate Components"
                # puts "Addr: #{new_full_address}"
            end

            img = detail.photos[0]
            img_url = img ? img.fetch_url(300) : nil
            coordinates = "#{spot.lat}, #{spot.lng}"

            raw_url = detail.website
            if raw_url

                if raw_url.include?("www.")
                    url = raw_url
                else
                    url = raw_url.gsub("//", "//www.")
                end

                uri = URI(url)
                full_url = "#{uri.scheme}://#{uri.host}"

                host_parts = uri.host.split(".")
                root = host_parts[1]

                # puts
                # puts
                # puts "New: #{root}"
                puts "New: #{full_url}"
                # puts "--------------------"
            end

            raw_crm_url = location.crm_url
            if raw_crm_url

                if raw_crm_url.include?("www.")
                    crm_url = raw_crm_url
                else
                    crm_url = raw_crm_url.gsub("//", "//www.")
                end

                uri = URI(crm_url)
                uri_crm_url = "#{uri.scheme}://#{uri.host}"
            end

            if uri_crm_url[-1, 1] == ("/")
                clean_crm_url = uri_crm_url[0...-1]
            else
                clean_crm_url = uri_crm_url
            end

            puts "CRM: #{clean_crm_url}"
            puts
            puts

            if clean_crm_url == full_url
                location.update_attributes(img_url: img_url, latitude: spot.lat, longitude: spot.lng, street: street, city: city, coordinates: coordinates, state_code: state, postal_code: zip, geo_acct_name: spot.name, phone: detail.formatted_phone_number, map_url: detail.url, acct_name: spot.name, address: new_full_address, geo_full_addr: new_full_address, url: full_url, geo_root: root, location_status: "Geo Result", coord_id_arr: sfdc_id_finder(coordinates))
            else
                location.update_attributes(img_url: img_url, latitude: spot.lat, longitude: spot.lng, street: street, city: city, coordinates: coordinates, state_code: state, postal_code: zip, geo_acct_name: spot.name, phone: detail.formatted_phone_number, map_url: detail.url, address: nil, geo_full_addr: new_full_address, url: full_url, geo_root: root, coord_id_arr: sfdc_id_finder(coordinates))
            end



            # img = detail.photos[0]
            # img_url = img ? img.fetch_url(300) : nil
            # puts img_url

            # location.update_attributes(img_url: img_url, location_status: "IMG Search")

            cores = Core.where(sfdc_id: location.sfdc_id)
            cores.each do |core|
                core.update_attribute(:img_url, img_url)
            end


            # Location.create(latitude: spot.lat, longitude: spot.lng, street: street, city: city, coordinates: coordinates, acct_name: core.sfdc_acct, state_code: state, postal_code: zip, group_name: core.sfdc_group, ult_group_name: core.sfdc_ult_grp, source: "GEO", sfdc_id: core.sfdc_id, tier: core.sfdc_tier, sales_person: core.sfdc_sales_person, acct_type: core.sfdc_type, crm_root: core.sfdc_root, address: core.full_address, location_status: status, geo_acct_name: spot.name, phone: detail.formatted_phone_number, map_url: detail.url, hierarchy: "GEO", geo_full_addr: geo_address, crm_source: core.acct_source, url: full_url, geo_root: root, crm_url: core.sfdc_url, crm_franch_term: core.sfdc_franchise, crm_franch_cons: core.sfdc_franch_cons, crm_franch_cat: core.sfdc_franch_cat, crm_phone: core.sfdc_ph, crm_hierarchy: core.hierarchy, geo_type: "Geo Result", coord_id_arr: sfdc_id_finder(coordinates))


            ## core.update_attributes(bds_status: status, geo_status: status, geo_date: Time.new)

        end

    end


    def sfdc_id_finder(coordinates)
        Location.where(coordinates: coordinates).map(&:sfdc_id)
    end

    ######## CAUTION - SAVE ABOVE THIS LINE!  ##########


    def turbo_matcher
        locations = Location.where(crm_source: "Web")

        counter = 0
        locations.each do |location|
            cores = Core.where(sfdc_id: location.sfdc_id)
            cores.each do |core|

                geo_acct = location.geo_acct_name
                geo_full_addr = location.geo_full_addr
                geo_street = location.street
                geo_city = location.city
                geo_state = location.state_code
                geo_zip = location.postal_code
                geo_url = location.url
                geo_root = location.geo_root
                geo_phone = location.phone

                crm_acct = location.acct_name
                crm_full_addr = location.address
                crm_street = location.crm_street
                crm_city = location.crm_city
                crm_state = location.crm_state
                crm_zip = location.crm_zip
                crm_root = location.crm_root
                crm_url = location.crm_url
                crm_phone = location.crm_phone
                crm_source = location.crm_source
                core_staffer = core.staffer_status

                if crm_source == "Web" && core_staffer == "Web Contacts" && crm_root == geo_root
                    if geo_acct != crm_acct
                        counter += 1
                        puts "------------- #{counter} -------------"
                        puts
                        puts "GEO: #{geo_acct}"
                        puts "CRM: #{crm_acct}"
                        puts
                        location.update_attribute(:acct_name, location.geo_acct_name)

                        if geo_full_addr != crm_full_addr
                            puts "GEO: #{geo_full_addr}"
                            puts "CRM: #{crm_full_addr}"
                            puts
                            location.update_attributes(address: location.geo_full_addr, crm_street: location.street, crm_city: location.city, crm_state: location.state_code, crm_zip: location.postal_code)
                        end

                        if geo_phone != crm_phone
                            puts "GEO: #{geo_phone}"
                            puts "CRM: #{crm_phone}"
                            location.update_attribute(:crm_phone, location.phone)
                        end

                    end
                end
            end
        end

    end

    def web_acct_name_cleaner
        # terms = InHostPo.all
        # terms.each do |term|
            locations = Location.where(crm_source: "Web").where("geo_acct_name != acct_name")[0..10]

            locations.each do |location|

                cores = Core.where(sfdc_id: location.sfdc_id).where.not(staffer_status: 'Web Contacts').where(acct_source: 'Web')

                counter = 0
                cores.each do |core|

                    geo_acct = location.geo_acct_name
                    geo_full_addr = location.geo_full_addr
                    geo_street = location.street
                    geo_city = location.city
                    geo_state = location.state_code
                    geo_zip = location.postal_code
                    geo_url = location.url
                    geo_root = location.geo_root
                    geo_phone = location.phone

                    crm_acct = location.acct_name
                    crm_full_addr = location.address
                    crm_street = location.crm_street
                    crm_city = location.crm_city
                    crm_state = location.crm_state
                    crm_zip = location.crm_zip
                    crm_root = location.crm_root
                    crm_url = location.crm_url
                    crm_phone = location.crm_phone
                    crm_source = location.crm_source
                    core_staffer = core.staffer_status

                    # if crm_source == "Web" && core_staffer == "Web Contacts" && crm_root == geo_root
                        # if geo_acct != crm_acct
                            counter += 1
                            puts "------------- #{counter} -------------"
                            puts
                            puts "GEO: #{geo_acct}"
                            puts "CRM: #{crm_acct}"
                            puts
                            # location.update_attribute(:acct_name, location.geo_acct_name)

                            if geo_full_addr != crm_full_addr
                                puts "GEO: #{geo_full_addr}"
                                puts "CRM: #{crm_full_addr}"
                                puts
                                # location.update_attributes(address: location.geo_full_addr, crm_street: location.street, crm_city: location.city, crm_state: location.state_code, crm_zip: location.postal_code)
                            end

                            if geo_phone != crm_phone
                                puts "GEO: #{geo_phone}"
                                puts "CRM: #{crm_phone}"
                                # location.update_attribute(:crm_phone, location.phone)
                            end

                        # end
                    # end
                end
            end

        # end


    end


    def street_cleaner
        ## changes long street type to short type.
        ## locations = Location.where("address LIKE '%Street%'")

        # locations = Location.where.not(address: nil)
        #
        # counter = 0
        # locations.each do |location|
        #
        #     crm_full_addr = location.address
        #     crm_full_addr_o = crm_full_addr
        #     crm_full_addr_n = street_cleaner_formatter(crm_full_addr)
        #
        #     geo_full_addr = location.geo_full_addr
        #     geo_full_addr_o = geo_full_addr
        #     geo_full_addr_n = street_cleaner_formatter(geo_full_addr)
        #
        #     geo_street = location.street
        #     geo_street_o = geo_street
        #     geo_street_n = street_cleaner_formatter(geo_street)

            # if crm_full_addr_n || geo_full_addr_n || geo_street_n
            #     counter +=1
            #     puts "-------- #{counter} ------------"
            #
            #     if crm_full_addr_n
            #         puts "CRM: #{crm_full_addr_n}"
            #         location.update_attribute(:address, crm_full_addr_n)
            #     end
            #
            #     if geo_full_addr_n
            #         puts "GEO: #{geo_full_addr_n}"
            #         location.update_attribute(:geo_full_addr, geo_full_addr_n)
            #     end
            #
            #     if geo_street_n
            #         puts "GEO: #{geo_street_n}"
            #         location.update_attribute(:street, geo_street_n)
            #     end
            # end
        # end
    end


    def street_cleaner_formatter(street)
        # if street
        #     if street.include?("Street")
        #         street_sub = street.gsub("Street", "St")
        #     elsif street.include?("Highway")
        #         street_sub = street.gsub("Highway", "Hwy")
        #     elsif street.include?("Boulevard")
        #         street_sub = street.gsub("Boulevard", "Blvd")
        #     elsif street.include?("Road")
        #         street_sub = street.gsub(" Road", " Rd")
        #     elsif street.include?("Drive")
        #         street_sub = street.gsub("Drive", "Dr")
        #     elsif street.include?("Lane")
        #         street_sub = street.gsub("Lane", "Ln")
        #     elsif street.include?("Parkway")
        #         street_sub = street.gsub("Parkway", "Pkwy")
        #     elsif street.include?("Expressway")
        #         street_sub = street.gsub("Expressway", "Expy")
        #     elsif street.include?("Route")
        #         street_sub = street.gsub("Route", "Rte")
        #     end
        # end
    end


    def make_bds_status_nil
        # cores = Core.where.not(bds_status: "Geo Result")
        # cores.each do |core|
        #     puts "--------------------------------"
        #     puts "bds_status: #{core.bds_status}"
        #     # core.update_attribute(:bds_status, nil)
        #     puts "bds_status: #{core.bds_status}"
        # end
    end


    def url_root_formatter
        # locations = Location.where("url LIKE '%https%'")[0..10]
        # locations = Location.where.not(url: nil)

        # locations = Location.where("geo_root = 'com' OR geo_root = 'org' OR geo_root = 'net'")
        # counter = 1
        # locations.each do |location|
        #     if location.url.include?("http")
        #         geo_url = location.url
        #         geo_root = location.geo_root
        #
        #         uri = URI(location.url)
        #         scheme = uri.scheme
        #         host = uri.host
        #         host_parts = host.split(".")
        #         root = host_parts[0]
        #         ext = host_parts[1]
        #
        #         puts counter
        #         puts geo_url
        #         puts "#{geo_root} | #{root}"
        #         puts "---------------------"
        #         puts
        #         counter +=1
        #
        #         location.update_attribute(:geo_root, root)
        #     end
        # end

    end


    def type_hierarchy_updater
        # cores = Core.all
        # counter = 0
        # cores.each do |core|
        #
        #     locs = Location.where(sfdc_id: core.sfdc_id)
        #     locs.each do |loc|
        #
        #         core_source = core.acct_source
        #         core_type = core.sfdc_type
        #         core_sfdc_sales_person = core.sfdc_sales_person
        #
        #         if core.acct_source == "Web"
        #             core_sfdc_sales_person = "Web"
        #             core_type = "Web"
        #         end
        #
        #         core.update_attributes(sfdc_sales_person: core_sfdc_sales_person, sfdc_type: core_type, hierarchy: "None")
        #
        #
        #         loc.update_attributes(sales_person: core.sfdc_sales_person, acct_type: core.sfdc_type, crm_source: core.acct_source, crm_hierarchy: "None", geo_type: "GEO")
        #
        #         counter +=1
        #         puts "Counter: #{counter}"
        #
        #     end
        # end
    end



    ##################################
    #### DEPRECATED METHODS BELOW #####
    ## GEO-CODER METHODS BELOW ##

    # def start_geo(cores) ## From Button
    #     cores.each do |core|
    #         core.update_attributes(bds_status: "Queue Geo", geo_status: nil, geo_date: nil, latitude: nil, longitude: nil, coordinates: nil)
    #
    #         create_sfdc_loc(core)
    #     end
    # end
    #
    # def geo_starter(ids)  ## From 'Queue Geo' Batch Select
    #     Core.where(id: ids).each do |core|
    #         create_sfdc_loc(core)
    #     end
    # end
    #
    # ## Main Geo Coder Method Starts Here ##
    # def create_sfdc_loc(core)
    #
    #     full_address = core.full_address
    #
    #     if core.bds_status == "Queue Geo"
    #
    #         if full_address == "Missing Address"
    #             core.update_attributes(bds_status: "Geo Error", geo_status: "Geo Error", geo_date: Time.new)
    #             # return
    #         else
    #             location = Location.new(address: core.full_address, street: core.sfdc_street, city: core.sfdc_city, state_code: core.sfdc_state, postal_code: core.sfdc_zip, acct_name: core.sfdc_acct, group_name: core.sfdc_group, ult_group_name: core.sfdc_ult_grp, source: core.acct_source, sfdc_id: core.sfdc_id, tier: core.sfdc_tier, sales_person: core.sfdc_sales_person, acct_type: core.sfdc_type, location_status: "Geo Result", url: core.sfdc_url, root: core.sfdc_root, franchise: core.sfdc_franch_cons, franch_cat: core.sfdc_franch_cat, hierarchy: core.hierarchy)
    #
    #             if location.save
    #                 core.update_attributes(bds_status: 'Geo Result', geo_status: 'Geo Result', geo_date: Time.new, latitude: location.latitude, longitude: location.longitude, coordinates: "#{location.latitude}, #{location.longitude}")
    #
    #                 location.update_attribute(:coordinates, core.coordinates)
    #
    #                 staffs = Staffers.where(sfdc_id: location.sfdc_id)
    #                 staffs.each do |staff|
    #                     staff.update_attributes(coordinates: location.coordinates, full_address: location.full_address)
    #                 end
    #
    #                 #== Throttle ====
    #                 # sleep(0.02)
    #
    #             else
    #                 core.update_attributes(bds_status: "Geo Error", geo_status: "Geo Error", geo_date: Time.new)
    #             end  ## if location.save
    #         end ## if addr = "Missing Address"
    #     end  ## if core.bds_status == "Queue Geo"
    # end  ## create_sfdc_loc(core)
    #
    # def location_cleaner_btn
    #     cores = Core.where.not(temporary_id: nil)
    #     cores.each do |core|
    #         locations = Location.where(sfdc_id: core.temporary_id, source: "Dealer")
    #         locations.each do |location|
    #             location.update_attributes(sfdc_id: core.sfdc_id)
    #         end
    #     end
    # end
    #
    # def geo_update_migrate_btn
    #
    #     ## Updates Coordinates - Starts
    #     # locations = Location.all
    #     # locations.each do |location|
    #     #     puts "-----------------------"
    #     #     puts "Account: #{location.acct_name}"
    #     #     puts "Current Coords: #{location.coordinates}"
    #     #     location.update_attribute(:coordinates, "#{location.latitude}, #{location.longitude}")
    #     #     puts "Updated Coords: #{location.coordinates}"
    #     #     puts "-----------------------"
    #     # end  ## Updates Coordinates - Ends
    #
    #     ## Updates SFDC data to Locations - Starts
    #     # cores = Core.where.not(temporary_id: nil)
    #     # cores.each do |core|
    #     #     split_locations = Location.where(sfdc_id: core.sfdc_id, source: "Dealer")
    #     #     split_locations.each do |split_location|
    #     #         split_location.update_attributes(sfdc_id: core.sfdc_id, acct_name: core.sfdc_acct, group_name: core.sfdc_group, ult_group_name: core.sfdc_ult_grp, source: "Web", tier: core.sfdc_tier, sales_person: core.sfdc_sales_person, acct_type: core.sfdc_type, url: core.sfdc_url, root: core.sfdc_root, franchise: core.sfdc_franch_cons, franch_cat: core.sfdc_franch_cat, hierarchy: "None")
    #     #     end
    #     # end
    #
    #     # cores = Core.where(temporary_id: nil)
    #     # cores.each do |core|
    #     #
    #     #     sfdc_locations = Location.where(sfdc_id: core.sfdc_id, source: "CRM")
    #     #
    #     #     sfdc_locations.each do |sfdc_location|
    #     #         sfdc_location.update_attributes(acct_name: core.sfdc_acct, group_name: core.sfdc_group, ult_group_name: core.sfdc_ult_grp, tier: core.sfdc_tier, sales_person: core.sfdc_sales_person, acct_type: core.sfdc_type, url: core.sfdc_url, root: core.sfdc_root, franchise: core.sfdc_franch_cons, franch_cat: core.sfdc_franch_cat, hierarchy: "None")
    #     #     end  ## sfdc_locations.each do |sfdc_location| - Ends
    #     # end  ## cores.each do |core| - Ends
    #
    #     ## Delete from Locations if Core.where(latitude: nil)
    #     ## Core.where(latitude: nil).count / 23,932
    #     # cores = Core.where(latitude: nil)
    #     # counter = 0
    #     # cores.each do |core|
    #     #     locations = Location.where(sfdc_id: core.sfdc_id)
    #     #
    #     #     locations.each do |location|
    #     #         puts "----------------------"
    #     #         puts "Core SFDC ID: #{core.sfdc_id}"
    #     #         puts "Location SFDC ID: #{location.sfdc_id}"
    #     #         # sfdc_location.update_attributes(:location_status, "DELETE!")
    #     #         puts "Counter: #{counter}"
    #     #         counter +=1
    #     #     end  ## locations.each do |location| - Ends
    #     # end  ## cores.each do |core| - Ends
    #
    # end  ## geo_update_migrate_btn - Ends
    ##################################

    ##################################

end  ## Locations Class - Ends
