class CobaltIndexer
    def initialize
        @indexer = IndexerService.new
    end

    def page_finder(text_list, href_list, url, page, mode)
        for text in text_list
            if pages = page.links.select {|link| link.text.downcase.include?(text.downcase)}
                @indexer.url_split_joiner(url, pages.first, mode)
                break
            end
        end

        if !pages
            href_list.delete(/MeetOurDepartments/) # /MeetOurDepartments/ is the last href to search.
            for href in href_list
                if pages = page.link_with(:href => href)
                    @indexer.url_split_joiner(url, pages, mode)
                    break
                end
            end

            if !pages
                if pages = page.link_with(:href => /MeetOurDepartments/)
                    @indexer.url_split_joiner(url, pages, mode)
                else
                    @indexer.add_indexer_row_with("Invalid Link", nil, nil, nil, mode)
                end
            end
        end
    end
end