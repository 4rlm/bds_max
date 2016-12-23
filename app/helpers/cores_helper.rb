module CoresHelper
    def core_status_list
        ['Dom Result', 'Imported', 'Matched', 'No Matches', 'Pending Verification', 'Isolate', 'Destroy', 'Junk', 'Queue Domainer', 'Queue Indexer']
    end

    def sfdc_sales_person_list
        ["Marc Peckler", "Ben Rosen", "Jason Price", "Sarah Thompson", "Justin Hufmeyer"]
    end

    def bds_status_list
        ["Destroy", "Dom Result", "Imported", "Matched", "No Matches", "Queue Domainer", "Queue Indexer"]
    end

    def sfdc_tier_list
        ["Tier 1", "Tier 2", "Tier 3", "Tier 4", "Tier 5"]
    end

    def url_comparison_list
        ["Different", "Same"]
    end

    def root_comparison_list
        ["Different", "Same"]
    end

    def indexer_status_list
        ["Ready", "Queued", "No Matches", "Matched"]
    end

    def staffer_status_list
        ["Ready", "Queued", "No Matches", "Matched"]
    end

    def whois_status_list
        ["Ready", "Queued", "No Matches", "Matched"]
    end

    def blank_remover(array)
        for i in 0...array.length
            if array[i] == ""
                array[i] = nil
            end
        end
        array.uniq
    end

    def formatted_date_list(datetime_arr)
        datetime_arr.map {|datetime| datetime.strftime("%m/%d/%Y") if datetime}.uniq
    end
end
