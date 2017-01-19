module ApplicationHelper
    def ordered_list(arr)
        arr.uniq!
        if arr.include?(nil)
            arr.delete(nil)
            arr.sort
        else
            arr.sort
        end
    end

    def sfdc_type_list
        ["Canceled", "Current Account", "Current Sub-account", "Distribution Partner", "Do Not Solicit", "Failure To Launch", "Group Division", "Group Name", "Inactive", "Influencer", "Max Digital Demo Store", "Prospect", "Prospect Sub-account", "Vendor", "Solitary"]
    end

    def core_status_list
        ['Imported', 'Queue Domainer', 'Dom Result', 'Matched', 'No Matches', 'Queue Indexer', 'Indexer Result', 'Queue Staffer', 'Staffer Result', 'Queue Geo', 'Geo Result', 'Geo Outbound', 'Destroy']
    end

    def sfdc_sales_person_list
        ["Marc Peckler", "Ben Rosen", "Jason Price", "Sarah Thompson", "Justin Hufmeyer", "Solitary"]
    end

    def status_list
        ['Dom Result', 'Imported', 'Auto-Match', 'No Auto-Matches', 'Matched', 'No Matches', 'Pending Verification', 'Solitary', 'Junk', 'Destroy']
    end

    def status_list_search
        ['Dom Result', 'No Auto-Matches']
    end

    def sfdc_tier_list
        ["Tier 1", "Tier 2", "Tier 3", "Tier 4", "Tier 5"]
    end

    def bds_status_list
        ['Imported', 'Queue Domainer', 'Dom Result', 'Matched', 'No Matches', 'Queue Indexer', 'Indexer Result', 'Queue Staffer', 'Staffer Result', 'Queue Geo', 'Geo Result', 'Geo Outbound', 'Destroy']
    end

    def sfdc_tier_list
        ["Tier 1", "Tier 2", "Tier 3", "Tier 4", "Tier 5"]
    end

    def comparison_list
        [["Different", "different"], ["Same", "same"]]
    end

    def staffer_status_list
        ["Ready", "Search Error", "Temp Error", "Queued", "No Matches", 'Try Again', "Scraped", 'Verified', 'Destroy', "Matched"]
    end

    def whois_status_list
        ["Ready", "Queued", "No Matches", "Matched"]
    end

    def location_geo_status_list
        ['Error', 'Geo Fail', 'Error: CRM Addy', 'No SFDC Addy', 'No Site Addy', 'Geo Result', 'Core Inbound', 'Geo Outbound', 'Merge Request', 'Merged', 'Geo Reverse', 'Update Core', 'Try Again', 'Destroy']
    end

    def geo_source_list
        ['Dealer', 'CRM', 'CoPilot']
    end

    def formatted_date_list(datetime_arr)
        datetime_arr.map {|datetime| datetime.strftime("%m/%d/%Y") if datetime}.uniq
    end

    def indexer_status_list
        ['Error', 'Indexer Result', 'Matched', 'No Matches', 'Queue Indexer', 'Ready', 'Try Again', 'Verified', 'Destroy']
    end

    def staffer_status_list
        ["Ready", "Search Error", "Temp Error", "Queued", "No Matches", 'Try Again', "Scraped", 'Verified', 'Destroy', "Matched"]
    end

    def franchise_list
        ['Acura', 'Alfa', 'Aston', 'Audi', 'Auto', 'Autogroup', 'Automall', 'Automotive', 'Autoplex', 'Autos', 'Autosales', 'Bentley', 'Benz', 'Bmw', 'Bugatti', 'Buick', 'Cadillac', 'Cars', 'Cdjr', 'Chev', 'Chevrolet', 'Chevy', 'Chrysler', 'Cjd', 'Corvette', 'Daewoo', 'Dealer', 'Dodge', 'Ferrari', 'Fiat', 'Ford', 'Gm', 'Gmc', 'Group', 'Highline', 'Honda', 'Hummer', 'Hyundai', 'Imports', 'Infiniti', 'Isuzu', 'Jaguar', 'Jeep', 'Kia', 'Lamborghini', 'Lexus', 'Lincoln', 'Lotus', 'Maserati', 'Mazda', 'Mb', 'Mclaren', 'Mercedes', 'Mercury', 'Mini', 'Mitsubishi', 'Motor', 'Motors', 'Nissan', 'Oldsmobile', 'Plymouth', 'Pontiac', 'Porsche', 'Ram', 'Range', 'Rolls', 'Rover', 'Royce', 'Saab', 'Saturn', 'Scion', 'Smart', 'Subaru', 'Superstore', 'Suzuki', 'Toyota', 'Trucks', 'Usedcars', 'Volkswagen', 'Volvo', 'Vw']
    end

    def template_list
        ['Dealer.com', 'DealerOn', 'Cobalt', 'DealerFire', 'DealerInspire', ["None", nil]]
    end

    def job_title_list
        ["CEO", "Dealer Principal", "Director", "Fixed Operations Manager", "Ecommerce Director", "General Manager", "General Sales Manager", "Internet Manager", "Internet Director", "Marketing Manager", "Marketing Director", "President", "Sales Manager", "Salesperson", "Used Car Manager", "Used Car Director", "Variable Operations Director", "Vice President" ]
    end

    def influence_list
        ["Decision Influencer", "Decision Maker", "Other", "N/A", ["None", nil]]
    end

    def inactive_list
        [["Active", "0"], ["Inactive", "1"]]
    end

    def contact_status_list
        ["Scraped", "SFDC", "Merged", "Merge-Request", "Hide", "Destroy"]
    end

    def contact_source_list
        ["Dealer Site", "SFDC", "Other"]
    end


    def state_list
        ['AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'DC', 'FL', 'GA', 'GU', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY']
    end




    def blank_remover(array)
        for i in 0...array.length
            if array[i] == ""
                array[i] = nil
            end
        end
        array.uniq
    end

    def percent_format(numerator, denominator)
        percent = (numerator / denominator.to_f) * 100
        number_to_percentage(percent, precision: 1)
    end


end
