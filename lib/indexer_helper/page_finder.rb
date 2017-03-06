class PageFinder
    def indexer_starter
        a=50
        z=60

        # els = Indexer.where(template: "Cobalt").where(indexer_status: "Link Unverified")[a...z] ##6669
        # els = Indexer.where(template: "DealerFire").where.not(indexer_status: "Link Unverified")[a...z] ##6669
        # els = Indexer.where(template: "Dealer Inspire").where.not(indexer_status: "Link Unverified")[a...z] ##6669
        # els = Indexer.where(template: "DealerOn").where.not(indexer_status: "Link Unverified")[a...z] ##6669
        # els = Indexer.where(template: "Dealer.com").where(indexer_status: "Link Unverified")[a...z] ##6669
        # els = Indexer.where(template: "DEALER eProcess").where.not(indexer_status: "Link Unverified")[a...z] ##6669

        els = Indexer.where(template: "Cobalt")[a...z]
        # els = Indexer.where(clean_url: "http://www.bouldernissan.com")
        # els = Indexer.where(clean_url: %w(http://www.bouldernissan.com http://www.nissan422oflimerick.com http://www.cavendercadillac.com http://www.alanwebbchevy.com http://www.lindsaycadillac.com))

        puts "count: #{els.count}\n\n\n"

        agent = Mechanize.new
        agent.follow_meta_refresh = true

        counter=0
        els.each do |el|
            @indexer = el

            counter+=1
            puts "\n[#{a}...#{z}]  (#{counter}):  #{el.template}\n----------------------------------------\n#{el.clean_url}\n"

            redirect_status = el.redirect_status
            if redirect_status == "Same" || redirect_status == "Updated"

                begin
                    @url = el.clean_url

                    begin
                        page = agent.get(@url)
                    rescue Mechanize::ResponseCodeError => e
                        redirect_url = HTTParty.get(@url).request.last_uri.to_s
                        page = agent.get(redirect_url)
                    end

                    page_finder(page, "staff")
                    page_finder(page, "location")
                rescue
                    error_msg = "Error: #{$!.message}"
                    status = nil
                    indexer_status = nil
                    found = false

                    indexer_terms = IndexerTerm.where(category: "url_redirect").where(sub_category: "error_msg")
                    indexer_terms.each do |term|
                        if error_msg.include?(term.criteria_term)
                            status = term.response_term
                            found = true
                        else
                            status = error_msg
                        end

                        indexer_status = status == "TCP Error" ? status : "Indexer Error"
                        break if found
                    end # indexer_terms iteration ends

                    indexer_status = "Indexer Error" unless found
                    # el.update_attributes(indexer_status: indexer_status, stf_status: status, staff_url: error_msg, loc_status: status, location_url: error_msg)
                end # rescue ends
                sleep(1)
            end
        end # Ends cores Loop
    end # Ends start_indexer(ids)

    def page_finder(page, mode)
        list = text_href_list(mode)

        text_list = list[:text_list]
        for text in text_list
            pages = page.links.select {|link| link.text.downcase.include?(text.downcase)}
            if pages.any?
                url_split_joiner(pages.first, mode)
                break
            end
        end

        if !pages
            href_list = list[:href_list]
            href_list.delete(/MeetOurDepartments/) # /MeetOurDepartments/ is the last href to search.
            for href in href_list
                if pages = page.link_with(:href => href)
                    url_split_joiner(pages, mode)
                    break
                end
            end

            if !pages
                if pages = page.link_with(:href => /MeetOurDepartments/)
                    url_split_joiner(pages, mode)
                else
                    add_indexer_row_with("Invalid Link", nil, nil, nil, mode)
                end
            end
        end
    end

    def url_split_joiner(pages, mode)
        url_s = @url.split('/')
        url_http = url_s[0]
        url_www = url_s[2]
        joined_url = validater(url_http, '//', url_www, pages.href)
        add_indexer_row_with("Valid Link", pages.text.strip, pages.href, joined_url, mode)
    end

    def add_indexer_row_with(status, text, href, link, mode)
        if mode == "location"
            puts "\n#{status}: #{text}\n#{link}\n#{text}\n----------------------------------------\n"
            # @indexer.update_attributes(indexer_status: "Indexer Result", loc_status: status, location_url: link, location_text: text) if @indexer != nil
        elsif mode == "staff"
            puts "\n#{status}: #{text}\n#{link}\n#{text}\n----------------------------------------\n"
            # @indexer.update_attributes(indexer_status: "Indexer Result", stf_status: status, staff_url: link, staff_text: text) if @indexer != nil
        end
    end

    def validater(url_http, dbl_slash, url_www, dirty_url)
        if dirty_url[0] != "/"
            dirty_url = "/" + dirty_url
        end

        if dirty_url.include?(url_http + dbl_slash)
            dirty_url
        else
            url_http + dbl_slash + url_www + dirty_url
        end
    end

    def to_regexp(arr)
        arr.map {|str| Regexp.new(str)}
    end

    def text_href_list(mode)
        if mode == "staff"
            text, href, term = "staff_text", "staff_href", @indexer.template
        elsif mode == "location"
            text, href, term = "loc_text", "loc_href", "general"
        end

        text_list = IndexerTerm.where(sub_category: text).where(criteria_term: term).map(&:response_term)
        href_list = to_regexp(IndexerTerm.where(sub_category: href).where(criteria_term: term).map(&:response_term))

        {text_list: text_list, href_list: href_list}
    end

end