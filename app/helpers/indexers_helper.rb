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

    def link_core_staffers_with_url(indexer)
        clean_url = indexer.clean_url
        core = Core.find_by(sfdc_clean_url: clean_url)
        link_name = indexer.contact_status ? indexer.contact_status : "No contact_status"

        if core
            link = <<-HTML
                #{link_to link_name, staffer_acct_contacts_path(core: core), :target => "_blank"}
            HTML
        else
            link = ""
        end

        count = <<-HTML
            <span class="badge" data-toggle="tooltip" data-placement="top" title="staff #">#{Staffer.where(domain: clean_url).count}</span>
        HTML
        (link + " " + count).html_safe
    end

end
