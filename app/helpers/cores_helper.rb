module CoresHelper

    # def blank_remover(array)
    #     for i in 0...array.length
    #         if array[i] == ""
    #             array[i] = nil
    #         end
    #     end
    #     array.uniq
    # end


    # def core_status_list
    #     ['Imported', 'Queue Domainer', 'Dom Result', 'Matched', 'No Matches', 'Queue Indexer', 'Indexer Result', 'Queue Staffer', 'Staffer Result', 'Queue Geo', 'Geo Result', 'Geo Outbound', 'Destroy']
    # end
    #
    # def sfdc_sales_person_list
    #     ["Marc Peckler", "Ben Rosen", "Jason Price", "Sarah Thompson", "Justin Hufmeyer", "Solitary"]
    # end
    #
    # def bds_status_list
    #     ['Imported', 'Queue Domainer', 'Dom Result', 'Matched', 'No Matches', 'Queue Indexer', 'Indexer Result', 'Queue Staffer', 'Staffer Result', 'Queue Geo', 'Geo Result', 'Geo Outbound', 'Destroy']
    # end
    #
    # def sfdc_tier_list
    #     ["Tier 1", "Tier 2", "Tier 3", "Tier 4", "Tier 5"]
    # end
    #
    # def comparison_list
    #     [["Different", "different"], ["Same", "same"]]
    # end
    #
    # def staffer_status_list
    #     ["Ready", "Search Error", "Temp Error", "Queued", "No Matches", 'Try Again', "Scraped", 'Verified', 'Destroy', "Matched"]
    # end
    #
    # def whois_status_list
    #     ["Ready", "Queued", "No Matches", "Matched"]
    # end

    def user_is_authorized?
        current_user && (current_user.intermediate? || current_user.advanced? || current_user.admin?)
    end

end
