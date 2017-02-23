require 'open-uri'
require 'mechanize'
require 'uri'
require 'nokogiri'
require 'socket'
require 'pry'
require 'httparty'



class IndexerService
#####################
### MAIN INDEXER METHODS !! Important!
#####################

    def indexer_starter
        snum = 0
        enum = 1
        # els = Indexer.where(indexer_status: "Re-Queue Indexer")[snum...enum]
        els = Indexer.where(indexer_status: nil).where.not(clean_url: nil)[snum...enum]

        # els = Indexer.where(indexer_status: "TCP Error")[snum...enum]


        @agent = Mechanize.new
        @agent.follow_meta_refresh = true

        locations_text_list = CriteriaIndexerLocText.all.map(&:term)
        locations_href_list = to_regexp(CriteriaIndexerLocHref.all.map(&:term))
        staff_text_list = CriteriaIndexerStaffText.all.map(&:term)
        staff_href_list = to_regexp(CriteriaIndexerStaffHref.all.map(&:term))

        counter=0
        els.each do |el|

            counter+=1
            puts "[#{snum}...#{enum}]"
            puts "------------------- #{counter} ---------------------"

            redirect_status = el.redirect_status
                if redirect_status == "Same" || redirect_status == "Updated"

                @cols_hash = {
                    indexer_status: nil,
                    domain: el[:clean_url],
                    text: nil,
                    href: nil,
                    link: nil
                }

                begin
                    url = @cols_hash[:domain]

                    begin
                        page = @agent.get(url)
                    rescue Mechanize::ResponseCodeError => e
                        redirect_url = HTTParty.get(url).request.last_uri.to_s
                        page = @agent.get(redirect_url)
                    end

                    puts "URL: #{url}"

                    page_finder(locations_text_list, locations_href_list, url, page, "location")
                    page_finder(staff_text_list, staff_href_list, url, page, "staff")

                rescue
                    error_alert = $!.message
                    error_msg = "Error: #{error_alert}"

                    ##################################
                    if error_msg
                        if error_msg.include?("TCP connection")
                            status = "TCP Error"
                            indexer_status = "TCP Error"
                        elsif error_msg.include?("403 => Net::HTTPForbidden")
                            status = "403 Error"
                        elsif error_msg.include?("410 => Net::HTTPGone")
                            status = "410 Error"
                        elsif error_msg.include?("500 => Net::HTTPInternalServerError")
                            status = "500 Error"
                        elsif error_msg.include?("SSL_connect returned")
                            status = "SSL Error"
                        elsif error_msg.include?("404 => Net::HTTPNotFound")
                            status = "404 Error"
                        elsif error_msg.include?("400 => Net::HTTPBadRequest")
                            status = "400 Error"
                        elsif error_msg.include?("nil:NilClass")
                            status = "Nil Error"
                        elsif error_msg.include?("undefined method")
                            status = "Method Error"
                        elsif error_msg.include?("503 => Net::HTTPServiceUnavailable")
                            status = "503 Error"
                        else
                            status = error_msg
                        end

                        indexer_status = "Indexer Error" unless indexer_status == "TCP Error"
                        el.update_attribute(:indexer_status, indexer_status)

                        puts
                        puts indexer_status
                        puts status
                        puts error_msg
                        puts

                        add_indexer_row_with(status, nil, nil, error_msg, "error")
                    end

                end

                throttle_delay_time = 2
                puts "--------------------------------"
                puts
                sleep(throttle_delay_time)

            end

        end # Ends cores Loop
    end # Ends start_indexer(ids)

    def page_finder(text_list, href_list, url, page, mode)
        for text in text_list
            if pages = page.link_with(:text => text)
                url_split_joiner(url, pages, mode)
                break
            end
        end

        # binding.pry
        if !pages
            for href in href_list
                if pages = page.link_with(:href => href)
                    url_split_joiner(url, pages, mode)
                    break
                end
            end

            if !pages
                add_indexer_row_with("No Matches", nil, nil, nil, mode)
            end
        end
    end # Ends page_finder

    def url_split_joiner(url, pages, mode)
        url_s = url.split('/')
        url_http = url_s[0]
        url_www = url_s[2]

        joined_url = validater(url_http, '//', url_www, pages.href)

        add_indexer_row_with("Matched", pages.text.strip, pages.href, joined_url, mode)
    end

    def add_indexer_row_with(status, text, href, link, mode)
        # binding.pry
        @cols_hash[:indexer_status] = status
        @cols_hash[:text] = text
        @cols_hash[:href] = href
        @cols_hash[:link] = link
        indexer = Indexer.find_by(raw_url: @cols_hash[:domain])

        if mode == "location"
            # IndexerLocation.create(@cols_hash)
            puts "#{status}: #{text}"
            indexer.update_attributes(indexer_status: "Indexer Result", loc_status: status, location_url: link, location_text: text) if indexer != nil
        elsif mode == "staff"
            # IndexerStaff.create(@cols_hash)
            puts "#{status}: #{text}"
            indexer.update_attributes(indexer_status: "Indexer Result", stf_status: status, staff_url: link, staff_text: text) if indexer != nil
        elsif mode == "error"
            puts "#{status}: #{text}"
            indexer.update_attributes(stf_status: status, staff_url: link, loc_status: status, location_url: link) if indexer != nil
        end

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

#####################
### indexer_starter Ends
#####################




#####################

    def reset_errors
        # indexers = Indexer.where(stf_status: "Error")[0..100]
        # indexers = Indexer.where("staff_url LIKE '%TCP connection%'")
        # indexers = Indexer.where(indexer_status: "Indexer Error")
        indexers = Indexer.all

        counter=0
        indexers.each do |indexer|

            puts
            counter+=1
            puts "Cleaning Record: #{counter} ....."

            indexer_status = indexer.indexer_status

            stf_status = indexer.stf_status
            staff_text = indexer.staff_text
            staff_url = indexer.staff_url

            loc_status = indexer.loc_status
            location_text = indexer.location_text
            location_url = indexer.location_url

            raw_url = indexer.raw_url
            clean_url = indexer.clean_url
            redirect_status = indexer.redirect_status


            if staff_text && staff_text.length > 35
                new_staff_text = staff_text[0..35]
                indexer.update_attribute(:staff_text, new_staff_text)
            end

            if location_text && location_text.length > 35
                new_location_text = location_text[0..35]
                indexer.update_attribute(:location_text, new_location_text)
            end

            if loc_status && loc_status == "Re-Queue"
                indexer.update_attribute(:loc_status, nil)
            end

            if stf_status && stf_status == "Re-Queue"
                indexer.update_attribute(:stf_status, nil)
            end

            if stf_status && (stf_status == "Matched" || stf_status == "No Matches") || loc_status && (loc_status == "Matched" || loc_status == "No Matches") && indexer_status != "Indexer Result"
                indexer.update_attribute(:indexer_status, "Indexer Result")
            end

            if redirect_status && redirect_status.include?("Error:")
                if redirect_status.include?("SSL connect error")
                    indexer.update_attributes(indexer_status: "Redirect Error", redirect_status: "SSL Error")
                elsif redirect_status.include?("Couldn't resolve host name")
                    indexer.update_attributes(indexer_status: "Redirect Error", redirect_status: "Host Error")
                elsif redirect_status.include?("Peer certificate")
                    indexer.update_attributes(indexer_status: "Redirect Error", redirect_status: "Certificate Error")
                elsif redirect_status.include?("Failure when receiving data")
                    indexer.update_attributes(indexer_status: "Redirect Error", redirect_status: "Transfer Error")
                else
                    indexer.update_attributes(indexer_status: "Redirect Error", redirect_status: "Error")
                end
            end

            if raw_url && clean_url
                if raw_url == clean_url
                    indexer.update_attribute(:redirect_status, "Same")
                else
                    indexer.update_attribute(:redirect_status, "Updated")
                end
            elsif raw_url == nil || clean_url == nil
                indexer.update_attribute(:redirect_status, nil)
            end

            if (staff_url && staff_url.include?("TCP connection")) || (location_url && location_url.include?("TCP connection"))
                status = "TCP Error"
                indexer.update_attributes(indexer_status: status, loc_status: status, stf_status: status, staff_text: nil, location_text: nil)
            elsif (staff_url && staff_url.include?("403 => Net::HTTPForbidden")) || (location_url && location_url.include?("403 => Net::HTTPForbidden"))
                status = "403 Error"
                indexer.update_attributes(indexer_status: "Indexer Error", loc_status: status, stf_status: status, staff_text: nil, location_text: nil)
            elsif (staff_url && staff_url.include?("410 => Net::HTTPGone")) || (location_url && location_url.include?("410 => Net::HTTPGone"))
                status = "410 Error"
                indexer.update_attributes(indexer_status: "Indexer Error", loc_status: status, stf_status: status, staff_text: nil, location_text: nil)
            elsif (staff_url && staff_url.include?("500 => Net::HTTPInternalServerError")) || (location_url && location_url.include?("500 => Net::HTTPInternalServerError"))
                status = "500 Error"
                indexer.update_attributes(indexer_status: "Indexer Error", loc_status: status, stf_status: status, staff_text: nil, location_text: nil)
            elsif (staff_url && staff_url.include?("SSL_connect returned")) || (location_url && location_url.include?("500 => Net::HTTPInternalServerError"))
                status = "SSL Error"
                indexer.update_attributes(indexer_status: "Indexer Error", loc_status: status, stf_status: status, staff_text: nil, location_text: nil)
            elsif (staff_url && staff_url.include?("404 => Net::HTTPNotFound")) || (location_url && location_url.include?("404 => Net::HTTPNotFound"))
                status = "404 Error"
                indexer.update_attributes(indexer_status: "Indexer Error", loc_status: status, stf_status: status, staff_text: nil, location_text: nil)
            elsif (staff_url && staff_url.include?("400 => Net::HTTPBadRequest")) || (location_url && location_url.include?("400 => Net::HTTPBadRequest"))
                status = "400 Error"
                indexer.update_attributes(indexer_status: "Indexer Error", loc_status: status, stf_status: status, staff_text: nil, location_text: nil)
            elsif (staff_url && staff_url.include?("nil:NilClass")) || (location_url && location_url.include?("nil:NilClass"))
                status = "Nil Error"
                indexer.update_attributes(indexer_status: "Indexer Error", loc_status: status, stf_status: status, staff_text: nil, location_text: nil)
            elsif (staff_url && staff_url.include?("undefined method")) || (location_url && location_url.include?("undefined method"))
                status = "Method Error"
                indexer.update_attributes(indexer_status: "Indexer Error", loc_status: status, stf_status: status, staff_text: nil, location_text: nil)
            elsif (staff_url && staff_url.include?("undefined method")) || (location_url && location_url.include?("503 => Net::HTTPServiceUnavailable"))
                status = "503 Error"
                indexer.update_attributes(indexer_status: "Indexer Error", loc_status: status, stf_status: status, staff_text: nil, location_text: nil)
            end


        end

    end


    #####################
    ### reset_errors Ends
    #####################


    def scraped_contacts_sts_checker

        indexers = Indexer.where.not(staff_text: nil).where(contact_status: nil).where.not(clean_url: nil)

        counter=0
        indexers.each do |indexer|

            clean_url = indexer.clean_url
            indexer_template = indexer.template
            contact_status = indexer.contact_status

            contacts = Staffer.where(domain: clean_url)[0..0]

            contacts.each do |contact|

                unless contact_status

                    staffer_status = contact.staffer_status
                    cont_status = contact.cont_status
                    staff_link = contact.staff_link
                    domain = contact.domain
                    staffer_template = contact.template

                    if domain == clean_url && contact_status == nil

                        counter+=1
                        puts
                        puts "------------------ #{counter} ------------------"
                        puts staffer_status
                        puts cont_status
                        puts staff_link
                        puts domain
                        puts staffer_template
                        puts

                        indexer.update_attributes(contact_status: "Scraped", template: staffer_template)

                    end

                end

            end

        end

    end


    def url_arr_extractor
        # locs = Location.where.not(url: nil).where.not(sts_duplicate: "URL Check")[0..-1]
        locs = Location.where.not(crm_url_redirect: nil)[0..-1]
        num=0
        print "#{num}, "


        loc_count=0
        indexer_count=0

        puts
        locs.each do |loc|
            loc_count+=1

            url_arr = loc.url_arr
            crm_url = loc.crm_url
            geo_url = loc.url
            crm_url_redirect = loc.crm_url_redirect
            geo_url_redirect = loc.geo_url_redirect

            exists = Indexer.exists?(raw_url: geo_url_redirect)

            if exists == false
                indexer_count+=1
                puts
                puts "(#{indexer_count}/#{loc_count}) Adding: #{geo_url_redirect}"
                loc.update_attribute(:sts_duplicate, "URL Check")
                Indexer.create(raw_url: geo_url_redirect)
            end

        end

        puts

    end


    def url_importer
        locs = Location.where.not(url: nil)
        counter=0
        locs.each do |loc|
            puts "#{counter}) #{loc.url}"
            Indexer.create(raw_url: loc.url)
        end
    end


    def url_redirect_checker
        require 'curb'
        # indexers = Indexer.where.not(crm_url: nil).where.not(crm_url: "").where("url != crm_url").where(crm_url_redirect: nil)
        # indexers = Indexer.where.not(crm_url: nil).where.not(crm_url: "").where("url != crm_url").where(geo_url_redirect: nil)[20...-1]
        indexers = Indexer.where(redirect_status: nil)[0..-1]

        counter_result = 0
        counter_fail = 0
        match_counter = 0
        total = 0
        indexers.each do |indexer|
            total +=1

            raw_url = indexer.raw_url

            begin ## rescue
                result = Curl::Easy.perform(raw_url) do |curl|
                    curl.follow_location = true
                    curl.useragent = "curb"
                    # curl.ssl_verify_peer = false
                end

                curb_url_result = result.last_effective_url

                crm_url_hash = url_formatter(curb_url_result)
                raw_url_final = crm_url_hash[:new_url]

                if raw_url != raw_url_final
                    counter_result +=1
                    puts "======= (#{counter_result}/#{total}) ======="
                    puts
                    puts "O: #{raw_url}"
                    puts "N: #{raw_url_final}"

                    indexer.update_attributes(redirect_status: "Updated", clean_url: raw_url_final)
                    puts
                    puts "==================================="
                else
                    puts "(#{total}): Same"
                    indexer.update_attributes(redirect_status: "Same", clean_url: raw_url_final)
                end

            rescue  #begin rescue
                error_message = $!.message
                counter_fail +=1
                final_error_msg = "Error: #{error_message}"
                puts "(#{counter_fail}/#{total})  (#{final_error_msg})"

                if final_error_msg && final_error_msg.include?("Error:")
                    if final_error_msg.include?("SSL connect error")
                        indexer.update_attributes(indexer_status: "Redirect Error", redirect_status: "SSL Error")
                    elsif final_error_msg.include?("Couldn't resolve host name")
                        indexer.update_attributes(indexer_status: "Redirect Error", redirect_status: "Host Error")
                    elsif final_error_msg.include?("Peer certificate")
                        indexer.update_attributes(indexer_status: "Redirect Error", redirect_status: "Certificate Error")
                    elsif final_error_msg.include?("Failure when receiving data")
                        indexer.update_attributes(indexer_status: "Redirect Error", redirect_status: "Transfer Error")
                    else
                        indexer.update_attributes(indexer_status: "Redirect Error", redirect_status: "Error")
                    end
                end
            end  #end rescue
        end
    end


    def url_formatter(url)
        unless url == nil || url == ""
            url.gsub!(/\P{ASCII}/, '')
            url = remove_slashes(url)
            if url.include?("\\")
                url_arr = url.split("\\")
                url = url_arr[0]
            end
            unless url.include?("www.")
                url = url.gsub!("//", "//www.")
            else
                url
            end

            uri = URI(url)
            new_url = "#{uri.scheme}://#{uri.host}"

            if uri.host
                host_parts = uri.host.split(".")
                new_root = host_parts[1]
            end
            return {new_url: new_url, new_root: new_root}
        end
    end


    def remove_slashes(url)
        # For rare cases w/ urls with mistaken double slash twice.
        parts = url.split('//')
        if parts.length > 2
            return parts[0..1].join
        end
        url
    end




#####################






#####################
####  STOP!!!!
#####################
# ORIGINAL INDEXER METHODS - SAVE

    # def start_indexer(ids)
    #     agent = Mechanize.new
    #     locations_text_list = CriteriaIndexerLocText.all.map(&:term)
    #     locations_href_list = to_regexp(CriteriaIndexerLocHref.all.map(&:term))
    #     staff_text_list = CriteriaIndexerStaffText.all.map(&:term)
    #     staff_href_list = to_regexp(CriteriaIndexerStaffHref.all.map(&:term))
    #
    #     Core.where(id: ids).each do |el|
    #         current_time = Time.new
    #
    #         @cols_hash = {
    #             indexer_status: nil,
    #             sfdc_acct: el[:sfdc_acct],
    #             domain: el[:matched_url],
    #             text: nil,
    #             href: nil,
    #             link: nil,
    #             sfdc_id: el[:sfdc_id]
    #         }
    #
    #         begin
    #             url = @cols_hash[:domain]
    #             page = agent.get(url)
    #
    #             page_finder(locations_text_list, locations_href_list, url, page, "location")
    #             page_finder(staff_text_list, staff_href_list, url, page, "staff")
    #
    #         rescue
    #             add_indexer_row_with("Error", "(none)", "(none)", $!.message, "error")
    #         end
    #
    #         el.update_attributes(indexer_date: current_time, bds_status: "Indexer Result")
    #
    #         # Throttle V1
    #         # delay_time = rand(30)
    #         # sleep(delay_time)
    #
    #         # Throttle V2
    #         #== Throttle (if needed) =====================
    #         # throttle_delay_time = (1..2).to_a.sample
    #         puts "Completed"
    #         # puts "Please wait #{throttle_delay_time} seconds."
    #         puts "--------------------------------"
    #         # sleep(throttle_delay_time)
    #
    #     end # Ends cores Loop
    # end # Ends start_indexer(ids)
    #
    # def page_finder(text_list, href_list, url, page, mode)
    #     for text in text_list
    #         if pages = page.link_with(:text => text)
    #             url_split_joiner(url, pages, mode)
    #             break
    #         end
    #     end
    #
    #     if !pages
    #         for href in href_list
    #             if pages = page.link_with(:href => href)
    #                 url_split_joiner(url, pages, mode)
    #                 break
    #             end
    #         end
    #
    #         if !pages
    #             add_indexer_row_with("No Matches", "(none)", "(none)", "(none)", mode)
    #         end
    #     end
    # end # Ends page_finder
    #
    # def url_split_joiner(url, pages, mode)
    #     url_s = url.split('/')
    #     url_http = url_s[0]
    #     url_www = url_s[2]
    #
    #     joined_url = validater(url_http, '//', url_www, pages.href)
    #
    #     add_indexer_row_with("Matched", pages.text.strip, pages.href, joined_url, mode)
    # end
    #
    # def add_indexer_row_with(status, text, href, link, mode)
    #     # binding.pry
    #     @cols_hash[:indexer_status] = status
    #     @cols_hash[:text] = text
    #     @cols_hash[:href] = href
    #     @cols_hash[:link] = link
    #     core = Core.find_by(sfdc_id: @cols_hash[:sfdc_id])
    #
    #     if mode == "location" || mode == "error"
    #         IndexerLocation.create(@cols_hash)
    #         core.update_attributes(location_indexer_status: status, location_link: link, location_text: text)
    #     end
    #
    #     if mode == "staff" || mode == "error"
    #         IndexerStaff.create(@cols_hash)
    #         core.update_attributes(staff_indexer_status: status, staff_link: link, staff_text: text)
    #     end
    # end
    #
    # def validater(url_http, dbl_slash, url_www, dirty_url)
    #     if dirty_url.include?(url_http + dbl_slash)
    #         dirty_url
    #     else
    #         url_http + dbl_slash + url_www + dirty_url
    #     end
    # end
    #
    # def to_regexp(arr)
    #     arr.map {|str| Regexp.new(str)}
    # end

#####################



end # IndexerService class Ends ---
