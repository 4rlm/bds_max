module CoresHelper
    def core_status_list
        ['Dom Result', 'Imported', 'Matched', 'No Matches', 'Pending Verification', 'Isolate', 'Destroy', 'Junk', 'Queue Domainer', 'Queue Indexer', 'Indexer Result']
    end

    def sfdc_sales_person_list
        ["Marc Peckler", "Ben Rosen", "Jason Price", "Sarah Thompson", "Justin Hufmeyer"]
    end

    def bds_status_list
        ["Destroy", "Dom Result", "Imported", "Matched", "No Matches", "Queue Domainer", "Queue Indexer", 'Indexer Result', 'Testing Status']
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
        ["Ready", "Queued", "No Matches", "Matched", "Error"]
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

    def get_gcse_domain_status(core)
        if gcse = Gcse.find_by(sfdc_id: core.sfdc_id)
            gcse.domain_status
        else
            "N/A"
        end
    end

    # def get_indexer_location_indexer_status(core)
    #     if indexer_location = IndexerLocation.find_by(sfdc_id: core.sfdc_id)
    #         indexer_location.indexer_status
    #     else
    #         "N/A"
    #     end
    # end

    def get_if_indexer_staff(core)
        if core.indexer_staff
            core.indexer_staff.indexer_status
        else
            "N/A"
        end
    end

    def indexer_list
        core_ids = IndexerStaff.all.map(&:core_id)
        cores_w_staff = @selected_data.where(id: core_ids).map do |core|
            core.indexer_staff if core.indexer_staff
        end
        ordered_list(cores_w_staff.map(&:indexer_status))
    end
end
