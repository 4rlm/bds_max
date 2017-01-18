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
        ["Canceled", "Current Account", "Current Sub-account", "Distribution Partner", "Do Not Solicit", "Failure To Launch", "Group Division", "Group Name", "Inactive", "Influencer", "Max Digital Demo Store", "Prospect", "Prospect Sub-account", "Vendor"]
    end

    def location_geo_status_list
        ['Error', 'Geo Fail', 'Geo Result', 'Geo Outbound', 'Merge Request', 'Merged', 'Geo Reverse', 'Update Core', 'Try Again', 'Destroy']
    end

end
