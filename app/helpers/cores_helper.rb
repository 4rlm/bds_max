module CoresHelper
    def core_status_list
        ['Imported', 'Queue Domainer', 'Dom Result', 'Matched', 'No Matches', 'Queue Indexer', 'Indexer Result', 'Queue Staffer', 'Staffer Result', 'Destroy']
    end

    def sfdc_sales_person_list
        ["Marc Peckler", "Ben Rosen", "Jason Price", "Sarah Thompson", "Justin Hufmeyer", "Solitary"]
    end

    def bds_status_list
        ['Imported', 'Queue Domainer', 'Dom Result', 'Matched', 'No Matches', 'Queue Indexer', 'Indexer Result', 'Queue Staffer', 'Staffer Result', 'Destroy']
    end

    def sfdc_tier_list
        ["Tier 1", "Tier 2", "Tier 3", "Tier 4", "Tier 5"]
    end

    # def url_comparison_list
    #     ["Different", "Same"]
    # end
    #
    # def root_comparison_list
    #     ["Different", "Same"]
    # end

    def comparison_list
        [["Different", "different"], ["Same", "same"]]
    end

    def staffer_status_list
        ["Ready", "Search Error", "Temp Error", "Queued", "No Matches", 'Try Again', "Scraped", 'Verified', 'Destroy', "Matched"]
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
