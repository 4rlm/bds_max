module GcsesHelper
    def status_list
        ['Dom Result', 'Imported', 'Auto-Match', 'No Auto-Matches', 'Matched', 'No Matches', 'Pending Verification', 'Solitary', 'Junk', 'Destroy']
    end

    def status_list_search
        ['Dom Result', 'No Auto-Matches']
    end

    def sfdc_tier_list
        ["Tier 1", "Tier 2", "Tier 3", "Tier 4", "Tier 5"]
    end

    def blank_remover(array)
        for i in 0...array.length
            if array[i] == ""
                array[i] = nil
            end
        end
        array.uniq
    end
end
