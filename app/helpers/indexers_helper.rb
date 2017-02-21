module IndexersHelper

    def indexer_indicator(crm, geo)
        unless (crm == nil || geo == nil) || (crm == "" || geo == "")
            return crm != geo ? "ind-green" : ""
        end
    end

    def match_sts_ind(input)
        if input
            return input == "Matched" ? "ind-green" : ""
        end
    end



end
