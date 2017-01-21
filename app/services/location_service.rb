class LocationService

    def start_geo(ids)
        Core.where(id: ids).each do |core|
            create_sfdc_loc(core)
            create_site_loc(core)
        end
    end

    def create_sfdc_loc(core)
        addr = full_address(core.sfdc_street, core.sfdc_city, core.sfdc_state, core.sfdc_zip)
        # return if addr.nil? || core.sfdc_geo_status == "Geo Result"
        # return if addr.nil? || core.sfdc_lat != nil

        puts
        puts "------ Current Query: -------"
        puts "Account Name: #{core.sfdc_acct}"
        puts "Account Type: #{core.sfdc_type}"
        puts "Address: #{addr}"
        puts "SFDC ID: #{core.sfdc_id}"
        puts "--------------------------------"

        if addr.nil?
            core.update_attributes(bds_status: "Geo Result", sfdc_geo_status: "No SFDC Addy")
            puts "SFDC: No SFDC Addy"
            return
        end

        if core.sfdc_lat != nil
            core.update_attributes(bds_status: "Geo Result", sfdc_geo_status: "Geo Result", sfdc_coordinates: "#{core.sfdc_lat}, #{core.sfdc_lon}")
            puts "SFDC: Coordinates Already Exist"
            puts "--------------------------------"
            return
        end


        location = Location.new(latitude: core.sfdc_lat, longitude: core.sfdc_lon, address: addr, street: core.sfdc_street, city: core.sfdc_city, state_code: core.sfdc_state, postal_code: core.sfdc_zip, coordinates: core.sfdc_coordinates, acct_name: core.sfdc_acct, group_name: core.sfdc_group, ult_group_name: core.sfdc_ult_grp, source: "CRM", sfdc_id: core.sfdc_id, tier: core.sfdc_tier, sales_person: core.sfdc_sales_person, acct_type: core.sfdc_type, location_status: "Core Inbound", url: core.sfdc_url, root: core.sfdc_root, franchise: core.sfdc_franchise)

        if location.save
            core.update_attributes(bds_status: 'Geo Result', site_geo_status: 'Geo Result', sfdc_geo_date: Time.new, sfdc_lat: location.latitude, sfdc_lon: location.longitude, sfdc_coordinates: "#{location.latitude}, #{location.longitude}")

            puts "---------------------"
            puts "SUCCESS!"
            puts "Lat: #{location.latitude}"
            puts "Lon: #{location.longitude}"
            puts "---------------------"
            puts

            #== Throttle (if needed) =====================
            # throttle_delay_time = (0..1).to_a.sample
            # puts "--------------------------------"
            # puts "Throttle: #{throttle_delay_time} seconds."
            # puts "--------------------------------"
            # sleep(throttle_delay_time)
            # sleep(0.02)
        else
            core.update_attributes(bds_status: "Geo Result", site_geo_status: "Error",
            site_geo_date: Time.new)
        end
    end

    def create_site_loc(core)
        addr = full_address(core.site_street, core.site_city, core.site_state, core.site_zip)
        # return if addr.nil? || core.site_geo_status == "Geo Result"
        # return if addr.nil? || core.site_lat != nil
        puts
        puts "------ Current Query: -------"
        puts "Account Name: #{core.site_acct}"
        puts "Account Type: #{core.sfdc_type}"
        puts "Address: #{addr}"
        puts "SFDC ID: #{core.sfdc_id}"
        puts "--------------------------------"

        if addr.nil?
            core.update_attributes(bds_status: "Geo Result", site_geo_status: "No Site Addy")
            puts "Site: No Site Addy"
            return
        end

        if core.site_lat != nil
            core.update_attributes(bds_status: "Geo Result", site_geo_status: "Geo Result", site_coordinates: "#{core.site_lat}, #{core.site_lon}")
            puts "SFDC: Coordinates Already Exist"
            puts "--------------------------------"
            return
        end


        location = Location.new(latitude: core.site_lat, longitude: core.site_lon, address: addr, street: core.site_street, city: core.site_city, state_code: core.site_state, postal_code: core.site_zip, coordinates: core.sfdc_coordinates, acct_name: core.site_acct, group_name: core.site_group, ult_group_name: core.site_ult_grp, source: "Dealer", sfdc_id: core.sfdc_id, tier: core.site_tier, sales_person: core.sfdc_sales_person, acct_type: core.sfdc_type, location_status: "Core Inbound", url: core.matched_url, root: core.matched_root, franchise: core.site_franchise)

        if location.save
            core.update_attributes(bds_status: 'Geo Result', site_geo_status: 'Geo Result', site_geo_date: Time.new, site_lat: location.latitude, site_lon: location.longitude, site_coordinates: "#{location.latitude}, #{location.longitude}")

            puts "---------------------"
            puts "SUCCESS!"
            puts "Lat: #{location.latitude}"
            puts "Lon: #{location.longitude}"
            puts "---------------------"
            puts

            # #== Throttle (if needed) =====================
            # throttle_delay_time = (0..1).to_a.sample
            # puts "--------------------------------"
            # puts "Throttle: #{throttle_delay_time} seconds."
            # puts "--------------------------------"
            # sleep(throttle_delay_time)
            # sleep(0.02)
        else
            core.update_attributes(bds_status: "Geo Result", site_geo_status: "Error",
            site_geo_date: Time.new)
        end
    end

    def full_address(street, city, state, zip)
        if street && city && state && zip
            return "#{street}, #{city}, #{state}, #{zip}"
        end
    end

end