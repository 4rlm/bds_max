require 'open-uri'
require 'mechanize'
require 'uri'
require 'nokogiri'
require 'socket'
require 'httparty'
require 'indexer_helper/rts/dealerfire_rts'
require 'indexer_helper/rts/cobalt_rts'
require 'indexer_helper/rts/dealer_inspire_rts'
require 'indexer_helper/rts/dealeron_rts'
require 'indexer_helper/rts/dealer_com_rts'
require 'indexer_helper/rts/dealer_direct_rts'
require 'indexer_helper/rts/dealer_eprocess_rts'
require 'indexer_helper/rts/dealercar_search_rts'
require 'indexer_helper/page_finder'  # Indexer Page Finder
require 'indexer_helper/rts/rts_helper'
require 'indexer_helper/rts/rts_manager'

class IndexerService
    def rooftop_data_getter # RoofTop Scraper
        a=20
        z=45
        # indexers = Indexer.where(template: "DealerOn").where.not(rt_sts: nil).where.not(clean_url: nil)[a...z]  ##852
        # indexers = Indexer.where(template: "DealerOn")[a...z]
        # indexers = Indexer.where(template: "Dealer.com")[a...z]
        # indexers = Indexer.where(template: "Cobalt")[a...z]
        # indexers = Indexer.where(rt_sts: "TCP Error").where.not(clean_url: nil)[a...z]
        # indexers = Indexer.where(template: "Cobalt").where(rt_sts: nil).where.not(clean_url: nil)[a...z]
        # indexers = Indexer.where(template: "Dealer Inspire").where.not(rt_sts: nil).where.not(clean_url: nil)[a...z]
        # indexers = Indexer.where(template: "Dealer Inspire")[a...z]
        # indexers = Indexer.where(template: "DealerFire").where(rt_sts: nil).where.not(clean_url: nil)[a...z]
        # indexers = Indexer.where(template: "DealerFire")[a...z]
        # indexers = Indexer.where(template: "Cobalt").where(rt_sts: nil).where.not(clean_url: nil)[a...z] #3792
        # indexers = Indexer.where(template: "DealerCar Search")[a...z]
        indexers = Indexer.where(template: "Dealer Direct")[a...z]

        # indexers = Indexer.where(template: "DEALER eProcess")[a...z]
        # indexers = Indexer.where(clean_url: %w(http://www.bigdiscountmotors.com))


        counter=0
        range = z-a
        indexers.each do |indexer|
            template = indexer.template
            clean_url = indexer.clean_url
            template == "Cobalt" ? url = "#{clean_url}/HoursAndDirections" : url = clean_url
            method = IndexerTerm.where(response_term: template).where.not(mth_name: nil).first
            term = method.mth_name

            counter+=1
            puts "\n#{'='*30}\n[#{a}...#{z}]  (#{counter}/#{range})"

            begin

                agent = Mechanize.new
                html = agent.get(url)

                case term
                when "dealer_com_rts"
                    DealerComRts.new.rooftop_scraper(html, url, indexer)
                when "cobalt_rts"
                    CobaltRts.new.rooftop_scraper(html, url, indexer)
                when "dealeron_rts"
                    DealeronRts.new.rooftop_scraper(html, url, indexer)
                when "dealercar_search_rts"
                    DealercarSearchRts.new.rooftop_scraper(html, url, indexer)
                when "dealer_direct_rts"
                    DealerDirectRts.new.rooftop_scraper(html, url, indexer)
                when "dealer_inspire_rts"
                    DealerInspireRts.new.rooftop_scraper(html, url, indexer)
                when "dealerfire_rts"
                    DealerfireRts.new.rooftop_scraper(html, url, indexer)
                when "dealer_eprocess_rts"
                    DealerEprocessRts.new.rooftop_scraper(html, url, indexer)
                end

            rescue
                error = $!.message
                error_msg = "RT Error: #{error}"
                if error_msg.include?("connection refused")
                    rt_error_code = "Connection Error"
                elsif error_msg.include?("undefined method")
                    rt_error_code = "Method Error"
                elsif error_msg.include?("404 => Net::HTTPNotFound")
                    rt_error_code = "404 Error"
                elsif error_msg.include?("TCP connection")
                    rt_error_code = "TCP Error"
                else
                    rt_error_code = error_msg
                end
                puts "\n\n>>> #{error_msg} <<<\n\n"

                # indexer.update_attributes(indexer_status: "RT Error", rt_sts: rt_error_code)
            end ## rescue ends

            sleep(3)
        end ## .each loop ends
    end # rooftop_data_getter ends


    ####################
    # TEMPLATE DETECTOR - STARTS
    ####################

    def template_finder
        a=0
        # z=50
        # a=50
        # z=100
        # a=100
        # z=150
        # a=150
        z=-1




        indexers = Indexer.where(indexer_status: "Target").where(template: nil)[a...z] ## 2,211
        # indexers = Indexer.where(clean_url: "http://www.howellnissan.com") ## 2,400

        # indexers = Indexer.where(template: "SFDC URL").where.not(clean_url: nil)[a...z] #1348
        # indexers = Indexer.where(template: "Unidentified").where.not(clean_url: nil)[a...z] #8047
        # indexers = Indexer.where(template: "Search Error").where(stf_status: "Matched")[a..z] #138
        # indexers = Indexer.where(template: "Dealer Inspire")[a..z]

        # indexers = Indexer.where(indexer_status: "Target").where(template: "Search Error")
        # indexers.each{|x| x.update_attribute(:template, nil)}



        counter=0
        indexers.each do |indexer|
            url = indexer.clean_url
            db_template = indexer.template
            criteria_term = nil
            template = nil
            counter+=1

            begin
                agent = Mechanize.new
                doc = agent.get(url)
                found = false

                indexer_terms = IndexerTerm.where(category: "template_finder").where(sub_category: "at_css")
                indexer_terms.each do |indexer_term|
                    criteria_term = indexer_term.criteria_term
                    if doc.at_css('html').text.include?(criteria_term)
                        found = true
                        template = indexer_term.response_term
                        puts "\n[#{a}...#{z}]  (#{counter})   Success!\nurl: #{url}\nTerm: #{criteria_term}\nTemp: #{template}\nDB: #{db_template}\n"
                        indexer.update_attribute(:template, template) if template
                        break
                    end
                end

                if !found # criteria_term not found
                    puts "\n[#{a}...#{z}]  (#{counter})   Unidentified\nurl\nTerm: #{criteria_term}\nTemp: #{template}\nDB: #{db_template}\n"
                    indexer.update_attribute(:template, "Unidentified")
                end

            rescue
                puts
                puts "[#{a}...#{z}]  (#{counter})   Search Error"
                puts url
                puts "Term: #{criteria_term}"
                puts "Temp: #{template}"
                puts "DB: #{db_template}"
                indexer.update_attribute(:template, "Search Error")
            end

            sleep(2)

        end
    end

    ####################
    # TEMPLATE DETECTOR - Ends
    ####################

    ####################
    # URL Redirect Checker - Starts
    ####################

    def url_redirect_checker
        require 'curb'
        # indexers = Indexer.where.not(crm_url: nil).where.not(crm_url: "").where("url != crm_url").where(crm_url_redirect: nil)
        # indexers = Indexer.where.not(crm_url: nil).where.not(crm_url: "").where("url != crm_url").where(geo_url_redirect: nil)[20...-1]
        # indexers = Indexer.where(redirect_status: nil).where(stf_status: "SFDC URL").where(indexer_status: "SFDC URL").where("raw_url LIKE '%http%'")[a...z]
        # indexers = Indexer.where(redirect_status: nil).where(stf_status: "SFDC URL").where(indexer_status: "SFDC URL").where("raw_url LIKE '%www%'")[a...z]
        # indexers = Indexer.where(redirect_status: nil).where(stf_status: "SFDC URL").where(indexer_status: "SFDC URL").where.not("raw_url LIKE '%www%'")[a...z]
        # Indexer.where.not("redirect_status LIKE '%Error%'")

        a=0
        z=-1

        indexers = Indexer.where(indexer_status: "COP URL").where(clean_url: nil)[a...z]  ##17,033


        counter_fail = 0
        counter_result = 0
        total = 0
        indexers.each do |indexer|
            total +=1

            raw_url = indexer.raw_url

            begin ## rescue
                result = Curl::Easy.perform(raw_url) do |curl|
                    curl.follow_location = true
                    curl.useragent = "curb"
                    curl.connect_timeout = 10
                    curl.enable_cookies = true
                    # curl.ssl_verify_peer = false
                end

                curb_url_result = result.last_effective_url

                crm_url_hash = url_formatter(curb_url_result)
                raw_url_final = crm_url_hash[:new_url]

                if raw_url != raw_url_final
                    counter_result +=1
                    puts
                    puts "[#{a}...#{z}] (#{counter_result}/#{total})"
                    puts "O: #{raw_url}"
                    puts "N: #{raw_url_final}"
                    puts "--------------------------------------------"
                    puts
                    indexer.update_attributes(redirect_status: "Updated", clean_url: raw_url_final)
                else
                    puts "[#{a}...#{z}] (#{total}): Same"
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

    ####################
    # URL Redirect Checker - Ends
    ####################



#####################



    def staff_url_cleaner
        # indexers = Indexer.where(template: "Search Error").where("staff_url LIKE '%.comstaff%'")
        indexers = Indexer.where(template: "Search Error").where(staff_url: nil)
        counter=0
        indexers.each do |indexer|
            staff_url = indexer.staff_url

            counter+=1
            puts "#{counter}) #{staff_url}"
            # new_staff_url = staff_url.gsub(".comstaff", ".com/staff")
            # puts new_staff_url
            puts
            # indexer.update_attributes(template: nil, staff_url: new_staff_url)
            indexer.update_attribute(:template, nil)
        end
    end


    def dup_url_cleaner
        bigs = Indexer.where.not(raw_url: nil)
        big_counter=0
        small_counter=0
        if bigs
            bigs.each do |big|
                big_raw_url = big.raw_url
                big_id = big.id

                pre_count = Indexer.where(raw_url: big_raw_url).count
                big_counter+=1
                puts
                puts "#{big_counter}) #{big_raw_url}"
                puts "pre_count: #{pre_count}"

                smalls = Indexer.where(raw_url: big_raw_url).where.not(id: big_id)
                smalls.each do |small|
                    small_raw_url = small.raw_url
                    small_id = small.id

                    small_counter+=1
                    puts "------------------ #{small_counter} ------------------ "
                    puts
                    puts "big_raw_url: #{big_raw_url}"
                    puts "small_raw_url: #{small_raw_url}"
                    puts "big_id: #{big_id}"
                    puts "small_id: #{small_id}"

                    small.destroy
                end

                post_count = Indexer.where(raw_url: big_raw_url).count
                puts "post_count: #{post_count}"
                puts
            end
        end
    end

    def url_downcase
        a=0
        z=-1
        indexers = Indexer.where.not(raw_url: nil)[a..z]
        counter=0
        indexers.each do |indexer|
            raw_url = indexer.raw_url
            down_raw_url = raw_url.downcase if raw_url
            counter+=1
            unless raw_url == down_raw_url
                puts
                puts "[#{a}...#{z}] (#{counter}) #{raw_url} / #{down_raw_url}"
                puts
                indexer.update_attribute(:raw_url, down_raw_url)
            end
        end
    end


    def hyrell_cleaner
        indexers = Indexer.where("raw_url LIKE '%.hyrell.%'")
        indexers.each do |indexer|
            raw_url = indexer.raw_url
            if raw_url.include?(".hyrell")
                puts
                new_raw_url = raw_url.gsub(".hyrell.", ".")
                puts raw_url
                puts new_raw_url
                indexer.update_attributes(raw_url: new_raw_url, redirect_status: nil)
            end
        end
    end


    def pending_verifications_importer
        pens = PendingVerification.all
        counter=0
        target_counter=0

        puts "\n\n======================================\n\n"

        pens.each do |pen|
            pen_url = pen.domain

            pen_url[-1] == "/" ? pen_url = pen_url[0...-1] : pen_url

            counter+=1
            raw_url = Indexer.exists?(raw_url: pen_url)
            clean_url = Indexer.exists?(clean_url: pen_url)

            if raw_url || clean_url
                puts "#{counter}/X) #{pen_url}"
            else
                target_counter+=1
                puts "#{counter}/#{target_counter})     IMPORTING: #{pen_url}"

                Indexer.create(raw_url: pen_url, indexer_status: "SFDC URL", stf_status: "SFDC URL", loc_status: "SFDC URL", template: "SFDC URL")
            end

        end

        puts "\n\n======================================\n\n"

    end


    def count_contacts
        indexers = Indexer.where.not(clean_url: nil).where(contacts_count: nil)
        counter=0
        indexers.each do |indexer|
            clean_url = indexer.clean_url
            contacts_count = Staffer.where(domain: clean_url).count

            counter+=1
            puts "---------------------- #{counter} ----------------------"
            puts clean_url
            puts contacts_count
            puts
            indexer.update_attribute(:contacts_count, contacts_count)
        end
    end


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
                elsif redirect_status.include?("Errno::ECONNRESET")
                    indexer.update_attributes(indexer_status: "Redirect Error", redirect_status: "Reset Error")
                elsif redirect_status.include?("Errno::ECONNRESET")
                    indexer.update_attributes(indexer_status: "504 => Net::HTTPGatewayTimeOut", redirect_status: "504 Error")
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


    def template_counter
        indexer_terms = IndexerTerm.where(sub_category: "at_css").where.not(response_term: nil)
        indexer_terms.each do |term|
            template = term.response_term
            temp_count = Indexer.where(template: template).count
            puts "#{template}: #{temp_count}"
            term.update_attribute(:response_count, temp_count)
        end
    end


    def stafflink_express
        # Dealer.com > "#{clean_url}/dealership/staff.htm"
        # DealerOn" > "#{clean_url}/staff.aspx"
        # Dealer Direct" > "#{clean_url}/staff"
        # DEALER eProcess > "#{clean_url}/meet-our-staff"

        indexers = Indexer.where(template: "DEALER eProcess").where.not(indexer_status: "Archived").where.not(indexer_status: "Staff Link Updated")

        indexers.each do |indexer|
            clean_url = indexer.clean_url
            staff_url = indexer.staff_url
            staff_text = indexer.staff_text
            unless clean_url.blank?
                new_link = "#{clean_url}/meet-our-staff"
                puts "staff_text: #{staff_text}"
                puts "clean_url: #{clean_url}"
                puts "staff_url: #{staff_url}"
                puts "new_link: #{new_link}"
                puts "-------------------------------"
                indexer.update_attributes(staff_url: new_link, indexer_status: "Staff Link Updated", staff_text: "Staff Page", stf_status: "Staff Link Updated")

                Indexer.where.not(template: nil).count
            end
        end

    end



    def core_phone_norm
        #normalizes phone in core sfdc accounts.
        cores = Core.where.not(sfdc_ph: nil)
        cores.each do |core|
            alert = ""
            sfdc_ph = core.sfdc_ph
            puts "sfdc_ph: #{sfdc_ph}"
            norm_ph = phone_formatter(sfdc_ph)
            if norm_ph != sfdc_ph
                alert = "Alert!"
                core.update_attribute(:sfdc_ph, norm_ph)
            end
            puts "norm_ph: #{norm_ph} #{alert}\n\n"
        end
    end

    def core_url_redirect
        #Checks if sfdc_url exists in Indexer raw_url column, then saves Indexer clean_url to core_url_redirect column.
        # cores = Core.where.not(sfdc_url: nil).where(sfdc_url_redirect: nil)
        # cores.each do |core|
        #     sfdc_url = core.sfdc_url
        #     sfdc_url_redirect = core.sfdc_url_redirect
        #     indexer_raw = Indexer.where(raw_url: sfdc_url).map(&:raw_url).first
        #     indexer_clean = Indexer.where(raw_url: sfdc_url).map(&:clean_url).first
        #     puts "\n\n============="
        #     puts sfdc_url
        #     puts indexer_raw
        #     puts indexer_clean
        #     core.update_attribute(:sfdc_url_redirect, indexer_clean)
        #     puts "=============\n\n"
        # end

        ## Step 2: Sends core sfdc_url to indexer raw_url if doesn't exist in indexer raw_url column.
        # cores = Core.where.not(sfdc_url: nil).where(sfdc_url_redirect: nil)
        # counter = 0
        # cores.each do |core|
        #     sfdc_url = core.sfdc_url
        #     raw_url = Indexer.where(raw_url: sfdc_url).first
        #     if raw_url.blank?
        #         counter +=1
        #         puts "=============\n\n"
        #         puts "counter: #{counter}"
        #         puts "sfdc_url: #{sfdc_url}"
        #         puts "raw_url: #{raw_url}"
        #         Indexer.create(indexer_status: "SFDC URL", redirect_status: "SFDC URL", raw_url: sfdc_url)
        #         puts "=============\n\n"
        #     end
        # end


        # cops = Indexer.where(redirect_status: "COP URL")
        # cops.each do |cop|
        #     raw_cop = cop.raw_url
        #     url_count = Indexer.where(raw_url: raw_cop).map(&:raw_url).count
        #     raw_keep = Indexer.where.not(id: cop.id).where(raw_url: raw_cop).map(&:raw_url).first
        #
        #     if raw_keep
        #         puts "\n\n========================\n\n"
        #         puts "url_count: #{url_count}"
        #         puts "raw_cop: #{raw_cop}"
        #         puts "raw_keep: #{raw_keep}"
        #         cop.update_attribute(:redirect_status, "Delete")
        #         puts "\n\n========================\n\n"
        #     end
        # end
    end


    def indexer_duplicate_purger
        # Indexer.select([:clean_url]).group(:clean_url).having("count(*) > 1").map.count
        # Indexer.select([:clean_url]).group(:clean_url).having("count(*) < 2").map.count
        # Indexer.all.map(&:template).uniq
        # Indexer.all.map(&:clean_url).uniq.count
        # Indexer.where.not(indexer_status: "Archived").count
    end





end # IndexerService class Ends ---
