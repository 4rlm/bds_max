class LocationService

    ## TRIAL VERSION BEGINS - NOT ORIGINAL
    ## THIS IS A CLEAN-UP VERSION FOR MISSING STREETS.

    def geo_places_starter
        ## ORIGINAL IS BASED ON "CORES".  THIS IS BASED ON "LOCATIONS".

        locations = Location.where(postal_code: nil)[20...-1]

        counter = 0
        locations.each do |location|
            counter += 1
            # puts "#{counter}: #{core.sfdc_acct}  |  #{core.sfdc_id}"
            puts "----- #{counter} -------"
            puts "INPUT:"
            puts "CRM Account: #{location.acct_name}  |  #{location.sfdc_id}"
            puts "GEO Account: #{location.geo_acct_name}"
            puts "CRM Address: #{location.address}"
            puts "GEO Address: #{location.geo_full_addr}"

            get_spot(location)
        end
    end

    # TRIAL VERSION BEGINS - NOT ORIGINAL
    # def get_spot(core)
    def get_spot(location)

        client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])

        if location.address != nil
            custom_query = "#{location.acct_name} near #{location.address}"
        else
            custom_query = location.acct_name
        end

        spots = client.spots_by_query(custom_query, types: ["car_dealer"], radius: 1)

        if spots.empty?
            # core.update_attributes(bds_status: "Geo Error", geo_status: "Geo Error", geo_date: Time.new)
            puts "Spots: Empty"
            return
        else
            spot = spots.first
            detail = client.spot(spot.reference)
            create_geo_place(location, spot, detail)
        end
    end

    def create_geo_place(location, spot, detail)

        comp = detail.address_components
        puts "---------------------------"
        puts "COMPONENTS:"
        puts comp

        street_num = detail.street_number
        street_text = detail.street
        detail_city = detail.city
        detail_zip = detail.postal_code
        vicinity = detail.vicinity
        formatted_address = detail.formatted_address

        puts "---------------------------"
        puts "DETAIL VARIABLES:"
        puts "street_num:#{street_num}"
        puts "street_text:#{street_text}"
        puts "detail_city:#{detail_city}"
        puts "detail_zip:#{detail_zip}"
        puts "vicinity:#{vicinity}"
        puts "---------------------------"
        puts "formatted_address:#{formatted_address}"

        if formatted_address.include?(", United States")

            new_formatted_address = formatted_address.gsub(", United States", "").strip
            puts "new_formatted_address:#{new_formatted_address}"

            new_formatted_address_arr = new_formatted_address.split(",")
            puts new_formatted_address_arr

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

            puts "-------"
            puts street
            puts city
            puts state
            puts zip

            unless street == city || city == state || state == zip

                street != nil || street != "" ? street_if = "#{street}, " : street_if = nil
                city != nil || city != "" ? city_if = "#{city}, " : city_if = nil
                state != nil || state != "" ? state_if = "#{state}, " : state_if = nil

                new_full_address = street_if+city_if+state_if+zip

                # if new_full_address[-1] == ","
                #   final_full_address = new_full_address[0...-1]
                # else
                #   final_full_address = new_full_address
                # end

            else
                new_full_address = "Error: Duplicate Components"
            end

            puts new_full_address

            img = detail.photos[0]
            img_url = img ? img.fetch_url(300) : nil

            coordinates = "#{spot.lat}, #{spot.lng}"
            puts "coordinates: #{coordinates}"

            url = detail.website


            if url
                uri = URI(url)
                full_url = "#{uri.scheme}://#{uri.host}"
                host_parts = uri.host.split(".")

                if url.include?("www.")
                    root = host_parts[1]
                else
                    root = host_parts[0]
                end

                puts "uri: #{uri}"
                puts "full_url: #{full_url}"
                puts "root: #{root}"
                puts "--------------------"
                puts
            end

            location.update_attributes(latitude: spot.lat, longitude: spot.lng, street: street, city: city, coordinates: coordinates, state_code: state, postal_code: zip, geo_acct_name: spot.name, phone: detail.formatted_phone_number, map_url: detail.url, img_url: img_url, geo_full_addr: new_full_address, url: full_url, geo_root: root, coord_id_arr: sfdc_id_finder(coordinates))

        end

    end


    # TRIAL VERSION - NOT ORIGINAL
    def sfdc_id_finder(coordinates)
        Location.where(coordinates: coordinates).map(&:sfdc_id)
    end


    # TRIAL VERSION ENDS - NOT ORIGINAL

    ######## CAUTION - SAVE ABOVE THIS LINE!  ##########






    # ORIGINAL GEO LOCATIONS METHODS - STARTS

    # def geo_places_starter
    #     cores = Core.where(bds_status: "Imported")[3..1000]
    #
    #     counter = 0
    #     cores.each do |core|
    #         counter += 1
    #         puts "----------------------------"
    #         puts "#{counter}: #{core.sfdc_acct}  |  #{core.sfdc_id}"
    #         get_spot(core)
    #     end
    # end

    # def get_spot(core)
    #     client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])
    #
    #     # spots = client.spots_by_query("#{core.sfdc_acct} near #{core.full_address}", name: core.sfdc_acct, types: ["car_dealer"], radius: 1)
    #     core.full_address ? custom_query = "#{core.sfdc_acct} near #{core.full_address}" : custom_query = core.sfdc_acct
    #     spots = client.spots_by_query(custom_query, name: core.sfdc_acct, types: ["car_dealer"], radius: 1)
    #
    #     if spots.empty?
    #         core.update_attributes(bds_status: "Geo Error", geo_status: "Geo Error", geo_date: Time.new)
    #         return
    #     else
    #         spot = spots.first
    #         detail = client.spot(spot.reference)
    #         create_geo_place(core, spot, detail)
    #     end
    # end

    # def create_geo_place(core, spot, detail)
    #     comp = detail.address_components
    #
    #     if comp
    #         if comp[0] && comp[1]
    #             street = comp[0]["short_name"] + " " + comp[1]["short_name"]
    #         elsif comp[0] == nil && comp[1]
    #             street = comp[1]["short_name"]
    #         elsif comp[0] && comp[1] == nil
    #             street = comp[0]["short_name"]
    #         else
    #             street = nil
    #         end
    #
    #         comp[2] ? city = comp[2]["short_name"] : city = nil
    #         # city = comp[2] ? comp[2]["short_name"] : nil
    #         comp[3] ? state = comp[3]["short_name"] : state = nil
    #         comp[5] ? zip = comp[5]["short_name"] : zip = nil
    #         status = "Geo Result"
    #         puts status
    #     else
    #         status = "Geo Error"
    #         puts status
    #     end
    #
    #     # img = detail.photos[0]
    #     # img_url = img ? img.fetch_url(300) : nil
    #
    #     coordinates = "#{spot.lat}, #{spot.lng}"
    #     geo_address = "#{street}, #{city}, #{state}, #{zip}"
    #
    #     ##############
    #
    #     url = detail.website
    #
    #         if url
    #             uri = URI(url)
    #             full_url = "#{uri.scheme}://#{uri.host}"
    #             host_parts = uri.host.split(".")
    #             root = host_parts[1]
    #
    #             puts "uri: #{uri}"
    #             puts "full_url: #{full_url}"
    #             puts "root: #{root}"
    #             puts "core.sfdc_url: #{core.sfdc_url}"
    #             puts "core.sfdc_root: #{core.sfdc_root}"
    #             puts "--------------------"
    #             puts
    #         end
    #
    #     Location.create(latitude: spot.lat, longitude: spot.lng, street: street, city: city, coordinates: coordinates, acct_name: core.sfdc_acct, state_code: state, postal_code: zip, group_name: core.sfdc_group, ult_group_name: core.sfdc_ult_grp, source: "GEO", sfdc_id: core.sfdc_id, tier: core.sfdc_tier, sales_person: core.sfdc_sales_person, acct_type: core.sfdc_type, crm_root: core.sfdc_root, address: core.full_address, location_status: status, geo_acct_name: spot.name, phone: detail.formatted_phone_number, map_url: detail.url, hierarchy: "GEO", geo_full_addr: geo_address, crm_source: core.acct_source, url: full_url, geo_root: root, crm_url: core.sfdc_url, crm_franch_term: core.sfdc_franchise, crm_franch_cons: core.sfdc_franch_cons, crm_franch_cat: core.sfdc_franch_cat, crm_phone: core.sfdc_ph, crm_hierarchy: core.hierarchy, geo_type: "Geo Result", coord_id_arr: sfdc_id_finder(coordinates))
    #
    #     core.update_attributes(bds_status: status, geo_status: status, geo_date: Time.new)
    # end
    #
    # def sfdc_id_finder(coordinates)
    #     Location.where(coordinates: coordinates).map(&:sfdc_id)
    # end

    # ORIGINAL GEO LOCATIONS METHODS - ENDS

    ######## CAUTION - SAVE ABOVE THIS LINE!  ##########







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
