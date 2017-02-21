module IndexersHelper

    def geo_indicator(crm, geo)
        unless (crm == nil || geo == nil) || (crm == "" || geo == "")
            return crm == geo ? "ind-green" : ""
        end
    end



end
