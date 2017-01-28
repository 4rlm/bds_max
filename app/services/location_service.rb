class LocationService

    def start_geo(cores) ## From Button
        cores.each do |core|
            core.update_attributes(bds_status: "Queue Geo", geo_status: nil, geo_date: nil, latitude: nil, longitude: nil, coordinates: nil)

            create_sfdc_loc(core)
        end
    end

    def geo_starter(ids)  ## From 'Queue Geo' Batch Select
        Core.where(id: ids).each do |core|
            create_sfdc_loc(core)
        end
    end


    ## Main Geo Coder Method Starts Here ##
    def create_sfdc_loc(core)

        full_address = core.full_address

        if core.bds_status == "Queue Geo"

            if full_address == "Missing Address"
                core.update_attributes(bds_status: "Geo Error", geo_status: "Geo Error", geo_date: Time.new)
                # return
            else
                location = Location.new(address: core.full_address, street: core.sfdc_street, city: core.sfdc_city, state_code: core.sfdc_state, postal_code: core.sfdc_zip, acct_name: core.sfdc_acct, group_name: core.sfdc_group, ult_group_name: core.sfdc_ult_grp, source: core.acct_source, sfdc_id: core.sfdc_id, tier: core.sfdc_tier, sales_person: core.sfdc_sales_person, acct_type: core.sfdc_type, location_status: "Geo Result", url: core.sfdc_url, root: core.sfdc_root, franchise: core.sfdc_franch_cons, franch_cat: core.sfdc_franch_cat, hierarchy: core.hierarchy)

                if location.save
                    core.update_attributes(bds_status: 'Geo Result', geo_status: 'Geo Result', geo_date: Time.new, latitude: location.latitude, longitude: location.longitude, coordinates: "#{location.latitude}, #{location.longitude}")

                    location.update_attribute(:coordinates, core.coordinates)

                    staffs = Staffers.where(sfdc_id: location.sfdc_id)
                    staffs.each do |staff|
                        staff.update_attributes(coordinates: location.coordinates, full_address: location.full_address)
                    end

                    #== Throttle ====
                    # sleep(0.02)

                else
                    core.update_attributes(bds_status: "Geo Error", geo_status: "Geo Error", geo_date: Time.new)
                end  ## if location.save
            end ## if addr = "Missing Address"
        end  ## if core.bds_status == "Queue Geo"
    end  ## create_sfdc_loc(core)


    def location_cleaner_btn
        cores = Core.where.not(temporary_id: nil)
        cores.each do |core|
            locations = Location.where(sfdc_id: core.temporary_id, source: "Dealer")
            locations.each do |location|
                location.update_attributes(sfdc_id: core.sfdc_id)
            end
        end
    end


    def geo_update_migrate_btn

        ## Updates Coordinates - Starts
        # locations = Location.all
        # locations.each do |location|
        #     puts "-----------------------"
        #     puts "Account: #{location.acct_name}"
        #     puts "Current Coords: #{location.coordinates}"
        #     location.update_attribute(:coordinates, "#{location.latitude}, #{location.longitude}")
        #     puts "Updated Coords: #{location.coordinates}"
        #     puts "-----------------------"
        # end  ## Updates Coordinates - Ends

        ## Updates SFDC data to Locations - Starts
        # cores = Core.where.not(temporary_id: nil)
        # cores.each do |core|
        #     split_locations = Location.where(sfdc_id: core.sfdc_id, source: "Dealer")
        #     split_locations.each do |split_location|
        #         split_location.update_attributes(sfdc_id: core.sfdc_id, acct_name: core.sfdc_acct, group_name: core.sfdc_group, ult_group_name: core.sfdc_ult_grp, source: "Web", tier: core.sfdc_tier, sales_person: core.sfdc_sales_person, acct_type: core.sfdc_type, url: core.sfdc_url, root: core.sfdc_root, franchise: core.sfdc_franch_cons, franch_cat: core.sfdc_franch_cat, hierarchy: "None")
        #     end
        # end

        # cores = Core.where(temporary_id: nil)
        # cores.each do |core|
        #
        #     sfdc_locations = Location.where(sfdc_id: core.sfdc_id, source: "CRM")
        #
        #     sfdc_locations.each do |sfdc_location|
        #         sfdc_location.update_attributes(acct_name: core.sfdc_acct, group_name: core.sfdc_group, ult_group_name: core.sfdc_ult_grp, tier: core.sfdc_tier, sales_person: core.sfdc_sales_person, acct_type: core.sfdc_type, url: core.sfdc_url, root: core.sfdc_root, franchise: core.sfdc_franch_cons, franch_cat: core.sfdc_franch_cat, hierarchy: "None")
        #     end  ## sfdc_locations.each do |sfdc_location| - Ends
        # end  ## cores.each do |core| - Ends

        ## Delete from Locations if Core.where(latitude: nil)
        ## Core.where(latitude: nil).count / 23,932
        # cores = Core.where(latitude: nil)
        # counter = 0
        # cores.each do |core|
        #     locations = Location.where(sfdc_id: core.sfdc_id)
        #
        #     locations.each do |location|
        #         puts "----------------------"
        #         puts "Core SFDC ID: #{core.sfdc_id}"
        #         puts "Location SFDC ID: #{location.sfdc_id}"
        #         # sfdc_location.update_attributes(:location_status, "DELETE!")
        #         puts "Counter: #{counter}"
        #         counter +=1
        #     end  ## locations.each do |location| - Ends
        # end  ## cores.each do |core| - Ends

    end  ## geo_update_migrate_btn - Ends

end  ## Locations Class - Ends
