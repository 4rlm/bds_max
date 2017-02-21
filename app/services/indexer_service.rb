require 'open-uri'
require 'mechanize'
require 'uri'
require 'nokogiri'
require 'socket'
require 'pry'



class IndexerService


####################

    def indexer_starter
        indexers = Indexer.where(indexer_status: nil).where.not(clean_url: nil)[0..10]

        if redirect_status == "Same" || redirect_status == "Updated"

            start_indexer(indexers)
            puts "Starting indexer..."
            # indexers.each do |indexer|
            #     start_indexer(indexer)
            # end

        end

    end


#####################
# SAMPLE INDEXER METHODS
#####################

    def start_indexer(ids)
        agent = Mechanize.new
        locations_text_list = CriteriaIndexerLocText.all.map(&:term)
        locations_href_list = to_regexp(CriteriaIndexerLocHref.all.map(&:term))
        staff_text_list = CriteriaIndexerStaffText.all.map(&:term)
        staff_href_list = to_regexp(CriteriaIndexerStaffHref.all.map(&:term))

        Core.where(id: ids).each do |el|
            current_time = Time.new

            @cols_hash = {
                indexer_status: nil,
                sfdc_acct: el[:sfdc_acct],
                domain: el[:matched_url],
                text: nil,
                href: nil,
                link: nil,
                sfdc_id: el[:sfdc_id]
            }

            begin
                url = @cols_hash[:domain]
                page = agent.get(url)

                page_finder(locations_text_list, locations_href_list, url, page, "location")
                page_finder(staff_text_list, staff_href_list, url, page, "staff")

            rescue
                add_indexer_row_with("Error", "(none)", "(none)", $!.message, "error")
            end

            el.update_attributes(indexer_date: current_time, bds_status: "Indexer Result")

            # Throttle V1
            # delay_time = rand(30)
            # sleep(delay_time)

            # Throttle V2
            #== Throttle (if needed) =====================
            # throttle_delay_time = (1..2).to_a.sample
            puts "Completed"
            # puts "Please wait #{throttle_delay_time} seconds."
            puts "--------------------------------"
            # sleep(throttle_delay_time)

        end # Ends cores Loop
    end # Ends start_indexer(ids)

    def page_finder(text_list, href_list, url, page, mode)
        for text in text_list
            if pages = page.link_with(:text => text)
                url_split_joiner(url, pages, mode)
                break
            end
        end

        if !pages
            for href in href_list
                if pages = page.link_with(:href => href)
                    url_split_joiner(url, pages, mode)
                    break
                end
            end

            if !pages
                add_indexer_row_with("No Matches", "(none)", "(none)", "(none)", mode)
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
        core = Core.find_by(sfdc_id: @cols_hash[:sfdc_id])

        if mode == "location" || mode == "error"
            IndexerLocation.create(@cols_hash)
            core.update_attributes(location_indexer_status: status, location_link: link, location_text: text)
        end

        if mode == "staff" || mode == "error"
            IndexerStaff.create(@cols_hash)
            core.update_attributes(staff_indexer_status: status, staff_link: link, staff_text: text)
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

        indexers = Indexer.where(redirect_status: nil)[0..0]

        counter_result = 0
        counter_fail = 0
        match_counter = 0
        total = 0
        indexers.each do |indexer|
            total +=1

            raw_url = indexer.raw_url

            # unless geo_url_first == nil || geo_url_first == ""
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
                    # $!.message
                    # puts $!.message
                    error_message = $!.message
                    counter_fail +=1
                    final_error_msg = "Error: #{error_message}"
                    puts "(#{counter_fail}/#{total})  (#{final_error_msg})"
                    indexer.update_attribute(:redirect_status, final_error_msg)
                end  #end rescue
            # end

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
