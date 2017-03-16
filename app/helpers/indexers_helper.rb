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

    def link_core_staffers(sfdc_ids)
        htmls = []
        sfdc_ids.each do |sfdc_id|
            core = Core.find_by(sfdc_id: sfdc_id)
            html = <<-HTML
                #{link_to sfdc_id, staffer_acct_contacts_path(core: core), :target => "_blank"}
            HTML
            htmls << html
        end
        htmls.join(' ').html_safe
    end

end
