require 'open-uri'
require 'mechanize'
require 'uri'
require 'nokogiri'
require 'socket'
require 'pry'

class IndexerService
    def start_indexer(ids)
        agent = Mechanize.new
        locations_text_list = CriteriaIndexerLocText.all.map(&:term)
        locations_href_list = to_regexp(CriteriaIndexerLocHref.all.map(&:term))
        staff_text_list = CriteriaIndexerStaffText.all.map(&:term)
        staff_href_list = to_regexp(CriteriaIndexerStaffHref.all.map(&:term))

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

                # Throttle V1
                delay_time = rand(15)
                sleep(delay_time)

                # Throttle V2
                #== Throttle (if needed) =====================
                # throttle_delay_time = (3..20).to_a.sample
                # puts "--------------------------------"
                # puts "SFDC_ID: #{id}"
                # puts "ACCT NAME: #{acct}"
                # puts "SFDC_URL: #{url_o}"
                # puts "SFDC_ROOT: #{sfdc_root}"
                # puts "--------------------------------"
                # puts "Please wait #{throttle_delay_time} seconds."
                # puts "--------------------------------"
                # sleep(throttle_delay_time)

            rescue
                add_indexer_row_with("Error", "IP Not Found", "(none)", "(none)", $!.message)
            end

        end # Ends cores Loop
    end # Ends start_indexer(ids)

    # # Adam Version Starts
    # def page_finder(text_list, href_list, url, page)
    #     for i in 0...(text_list.length)
    #         if pages = page.link_with(:text => text_list[i])
    #             url_split_joiner(url, pages)
    #             break
    #         end
    #     end
    # # Adam Version Ends

    # Original Starts
    def page_finder(text_list, href_list, url, page)
        for text in text_list
            if pages = page.link_with(:text => text)
                # binding.pry
                url_split_joiner(url, pages)
                break
            end
        end
    # Original Ends

        if !pages
            for href in href_list
                if pages = page.link_with(:href => href)
                    # binding.pry
                    url_split_joiner(url, pages)
                    break
                end
            end

            if !pages
                ip = ip_grab(url)

                # binding.pry
                add_indexer_row_with("No Matches", ip, "(none)", "(none)", "(none)")

                # puts "NO MATCHES.  Found IP " + ip + " for " +  url
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
        # binding.pry
        @cols_hash[:indexer_status] = status
        @cols_hash[:ip] = ip
        @cols_hash[:text] = text
        @cols_hash[:href] = href
        @cols_hash[:link] = link

        puts "\n>>>>Gahee @cols_hash: #{@cols_hash}\n"
        IndexerLocation.create(@cols_hash)
        IndexerStaff.create(@cols_hash)
    end

    def validater(url_http, dbl_slash, url_www, dirty_url)
        if dirty_url.include?(url_http + dbl_slash)
            dirty_url
        else
            url_http + dbl_slash + url_www + dirty_url
        end
    end

    def to_regexp(arr)
        arr.map {|str| Regexp.new(str)}
    end

end # IndexerService class Ends ---
