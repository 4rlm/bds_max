require 'open-uri'
require 'mechanize'
require 'uri'
require 'nokogiri'
require 'socket'

class IndexerService
    def start_indexer(ids)
        agent = Mechanize.new
        locations_text_list = CriteriaIndexerLocText.all.map(&:term)
        locations_href_list CriteriaIndexerLocHref.all.map(&:term)
        staff_text_list = CriteriaIndexerStaffText.all.map(&:term)
        staff_href_list = CriteriaIndexerStaffHref.all.map(&:term)

        Core.where(id: ids).each do |el|
            @cols_hash = {
                indexer_timestamp: Time.new,
                indexer_status: nil,
                sfdc_acct: el[:sfdc_acct],
                sfdc_group_name: el[:sfdc_group],
                sfdc_ult_acct: el[:sfdc_ult_grp],
                sfdc_id: el[:sfdc_id],
                domain: el[:matched_url],
                ip: nil,
                text: nil,
                href: nil,
                link: nil
            }

            begin
                url = @cols_hash[:domain]
                page = agent.get(url)

                page_finder(locations_text_list, locations_href_list, url, page)
                page_finder(staff_text_list, staff_href_list, url, page)

                # Throttle
                # delay_time = rand(42)
                # sleep(delay_time)
            rescue
                add_indexer_row_with("Error", "IP Not Found", "(none)", "(none)", $!.message)
            end

        end # Ends cores Loop
    end # Ends start_indexer(ids)

    def page_finder(text_list, href_list, url, page)
        for text in text_list
            if pages = page.link_with(:text => text)
                url_split_joiner(url, pages)
                break
            end
        end

        if !pages
            for href in href_list
                if pages = page.link_with(:href => href)
                    url_split_joiner(url, pages)
                    break
                end
            end

            if !pages
                ip = ip_grab(url)

                add_indexer_row_with("No Matches", ip, "(none)", "(none)", "(none)")

                puts "NO MATCHES.  Found IP " + ip + " for " +  url
            end
        end
    end # Ends page_finder

    def url_split_joiner(url, pages)
        url_s = url.split('/')
        url_http = url_s[0]
        url_www = url_s[2]

        ip = ip_grab(url)
        joined_url = validater(url_http, '//', url_www, pages.href)

        add_indexer_row_with("Matched", ip, pages.text.strip, pages.href, joined_url)
    end

    def ip_grab(url)
        url_s = url.split('/')
        url_www = url_s[2]
        IPSocket::getaddress(url_www)
    end

    def add_indexer_row_with(status, ip, text, href, link)
        @cols_hash[:indexer_status] = status
        @cols_hash[:ip] = ip
        @cols_hash[:text] = text
        @cols_hash[:href] = href
        @cols_hash[:link] = link

        indexer_location = IndexerLocation.create(@col_values)
        indexer_staff = IndexerStaff.create(@col_values)
    end

    def validater(url_http, dbl_slash, url_www, dirty_url)
        if dirty_url.include?(url_http + dbl_slash)
            dirty_url
        else
            url_http + dbl_slash + url_www + dirty_url
        end
    end

end # IndexerService class Ends ---
