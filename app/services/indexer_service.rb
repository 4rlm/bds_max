#===============
# INDEXER SERVICES
#===============
require 'open-uri'
require 'mechanize'
require 'uri'

require 'nokogiri'
require 'socket'

class IndexerService
    def initialize
        @agent = Mechanize.new
        # {|agent|
        #   agent.set_proxy '12.41.141.10', 8080
        #   agent.user_agent_alias = 'Mac Safari'
        # }
        @location_msg = "Locations Link"
        @staff_msg = "Staff Link"
        @col_array = ["indexer_date", "indexer_status", "acct", "sfdc_group", "ult_acct", "street", "city", "state", "type", "sfdc_tier", "sfdc_sales_person", "id", "root", "url", "ip", "pages.text.strip", "pages.href", "joined_url", "msg"]
    end

    def ip_grab(url)
        url_s = url.split('/')
        url_www = url_s[2]
        ip = IPSocket::getaddress(url_www)
        return ip
    end

    def validater(url_http, dbl_slash, url_www, dirty_url)
        if dirty_url.include?(url_http + dbl_slash)
            return dirty_url
        else
            return url_http + dbl_slash + url_www + dirty_url
        end
    end

    def url_split_joiner(indexer_date, indexer_status, acct, sfdc_group, ult_acct, street, city, state, type, sfdc_tier, sfdc_sales_person, id, root, url, pages, msg)
        # === Split-Joiner (plus ip getter) ===
        url_s = url.split('/')
        url_http = url_s[0]
        dbl_slash = '//'
        url_www = url_s[2]
        joined_url = validater(url_http, dbl_slash, url_www, pages.href)
        ip = ip_grab(url)

        col_array = [indexer_date, indexer_status, acct, sfdc_group, ult_acct, street, city, state, type, sfdc_tier, sfdc_sales_person, id, root, url, ip, msg, joined_url, pages.text.strip, pages.href]

        # === End = Split-Joiner (plus ip getter) ===
        add_indexer_location_row(col_array) if msg == @location_msg
        add_indexer_staff_row(col_array) if msg == @staff_msg

        # puts "SUCCESS!  Found IP " + ip + " for " + url + " => " + pages.text.strip
    end

    def page_finder(indexer_date, indexer_status, acct, sfdc_group, ult_acct, street, city, state, type, sfdc_tier, sfdc_sales_person, id, root, url, text_list, href_list, page, msg)
        for i in 0...(text_list.length)
            if pages = page.link_with(:text => text_list[i])
                url_split_joiner(indexer_date, indexer_status, acct, sfdc_group, ult_acct, street, city, state, type, sfdc_tier, sfdc_sales_person, id, root, url, pages, msg)
                break
            end
        end

        if !pages
            for i in 0...(href_list.length)
                if pages = page.link_with(:href => href_list[i])
                    url_split_joiner(indexer_date, indexer_status, acct, sfdc_group, ult_acct, street, city, state, type, sfdc_tier, sfdc_sales_person, id, root, url, pages, msg)
                    break
                end
            end

            if !pages
                no_match = "No Matches."
                p_text = "No hypertext"
                p_href = "No hrefs"
                no_ip = "IP not Found"
                ip = ip_grab(url)

                col_array = [indexer_date, indexer_status, acct, sfdc_group, ult_acct, street, city, state, type, sfdc_tier, sfdc_sales_person, id, root, url, ip, msg, no_match, p_text, p_href]

                add_indexer_location_row(col_array) if msg == @location_msg
                add_indexer_staff_row(col_array) if msg == @staff_msg

                puts "NO MATCHES.  Found IP " + ip + " for " +  url
            end
        end
    end # Ends page_finder

    # == Core Scraper Method starts here.========|*|
    def search(ids)
        # ====== Variables
        # agent = Mechanize.new
        # {|agent|
        #   agent.set_proxy '12.41.141.10', 8080
        #   agent.user_agent_alias = 'Mac Safari'
        # }

        # == Criteria ==
        locations_text_list = CriteriaIndexerLocText.all.map(&:term)

        locations_href_list CriteriaIndexerLocHref.all.map(&:term)

        staff_text_list = CriteriaIndexerStaffText.all.map(&:term)

        staff_href_list = CriteriaIndexerStaffHref.all.map(&:term)

        # = Code Starts =
            #==============
            # NEW: Converted fields to db fields.
            url_list = Core.where(id: ids).each do |el|
                acct = el[:sfdc_acct]
                sfdc_group = el[:sfdc_group]
                ult_acct = el[:sfdc_ult_grp]
                street = el[:sfdc_street]
                city = el[:sfdc_city]
                state = el[:sfdc_state]
                url = el[:matched_url]
                root = el[:matched_root]
                type = el[:sfdc_type]
                sfdc_tier = el[:sfdc_tier]
                sfdc_sales_person = el[:sfdc_sales_person]
                id = el[:sfdc_id]
            #==============
            # OLD: Need to convert CSV import mapping.
            # url_list.each do |el|
            #     id = el[:id]
            #     ult_acct = el[:ult_acct]
            #     acct = el[:acct]
            #     type = el[:type]
            #     street = el[:street]
            #     city = el[:city]
            #     state = el[:state]
            #     url_o = el[:url_o]
            #     url = el[:url]
                #==============

            begin #begin rescue p1
                # doc = Nokogiri::HTML(open(url))
                page = @agent.get(url)

                # Locations Page Finder Parameters
                page_finder(id, ult_acct, acct, type, street, city, state, url, locations_text_list, locations_href_list, page, @location_msg)

                # Staff Page Finder Parameters
                page_finder(id, ult_acct, acct, type, street, city, state, url, staff_text_list, staff_href_list, page, @staff_msg)

                # Throttle
                # delay_time = rand(42)
                # sleep(delay_time)

            rescue  #begin rescue p2
                $!.message
                bad_url = "Error: Please verify website URL."
                no_ip = "IP Not Found"

                col_array = [indexer_date, indexer_status, acct, sfdc_group, ult_acct, street, city, state, type, sfdc_tier, sfdc_sales_person, id, root, url, no_ip, $!.message, bad_url, bad_url, bad_url]

                add_indexer_location_row(col_array)
                add_indexer_staff_row(col_array)

                # puts bad_url + ": " + "#{url}"
                # puts $!.message
                # puts ""
                $!.message
            end  #end rescue

            # # puts "----- Completed Row: #{url_list.index(el) + 1} -------\n"
            # puts "---- Imported Row: #{url_list.index(el) + 2} ||  Exported Row: #{url_list.index(el) + 516} ----\n"
            # puts ""

        end # Loop "url_list" Ends --
    end # Search Main Method Ends --

    def add_indexer_location_row(indexer_date, indexer_status, acct, sfdc_group, ult_acct, street, city, state, type, sfdc_tier, sfdc_sales_person, id, root, url, ip, pages.text.strip, pages.href, joined_url, msg)

        indexer_location = IndexerLocation.new(
        indexer_timestamp: indexer_date,
        indexer_status: indexer_status,
        sfdc_acct: acct,
        sfdc_group_name: sfdc_group,
        sfdc_ult_acct: ult_acct,
        sfdc_street: street,
        sfdc_city: city,
        sfdc_state: state,
        sfdc_type: type,
        sfdc_tier: sfdc_tier,
        sfdc_sales_person: sfdc_sales_person,
        sfdc_id: id,
        root: root,
        domain: url,
        ip: ip,
        text: pages.text.strip,
        href: pages.href,
        link: joined_url,
        msg: msg
        )
        indexer_location.save
    end  # --- add_indexer_staff_row Method Ends ---

    def add_indexer_staff_row(indexer_date, indexer_status, acct, sfdc_group, ult_acct, street, city, state, type, sfdc_tier, sfdc_sales_person, id, root, url, ip, pages.text.strip, pages.href, joined_url, msg)

        indexer_staff = IndexerStaff.new(
            indexer_timestamp: indexer_date,
            indexer_status: indexer_status,
            sfdc_acct: acct,
            sfdc_group_name: sfdc_group,
            sfdc_ult_acct: ult_acct,
            sfdc_street: street,
            sfdc_city: city,
            sfdc_state: state,
            sfdc_type: type,
            sfdc_tier: sfdc_tier,
            sfdc_sales_person: sfdc_sales_person,
            sfdc_id: id,
            root: root,
            domain: url,
            ip: ip,
            text: pages.text.strip,
            href: pages.href,
            link: joined_url,
            msg: msg
            )
        indexer_staff.save
    end  # --- add_indexer_staff_row Method Ends ---

end # IndexerService class Ends ---
