module StaffersHelper
    def staffer_status_list
        ["Ready", "Search Error", "Temp Error", "Queued", "No Matches", 'Try Again', "Scraped", 'Verified', 'Destroy', "Matched"]
    end
end
