require 'mechanize'
require 'nokogiri'
require 'open-uri'
# require_relative 'staffer_service_helper'

# class StafferService

    # def start_staffer(ids)
    #     Core.where(id: ids).each do |el|
    #         current_time = Time.new
    #
    #         @cols_hash = {
    #             sfdc_id: el[:sfdc_id],
    #             acct_name: el[:sfdc_acct],
    #             group_name: el[:sfdc_group],
    #             ult_group_name: el[:sfdc_ult_grp],
    #             sfdc_sales_person: el[:sfdc_sales_person],
    #             sfdc_type: el[:sfdc_type],
    #             sfdc_tier: el[:sfdc_tier],
    #             staff_link: el[:staff_link],
    #             staff_text: el[:staff_text],
    #             domain: el[:matched_url],
    #             staffer_date: current_time,
    #             staffer_status: nil,
    #             template: nil,
    #             # acct_name: nil,
    #             street: nil,
    #             city: nil,
    #             state: nil,
    #             zip: nil,
    #             phone: nil,
    #             job_raw: nil,
    #             fname: nil,
    #             lname: nil,
    #             fullname: nil,
    #             email: nil,
    #             cont_status: nil,
    #             cont_source: nil,
    #             influence: nil
    #         }
    #
    #         search(el, @cols_hash[:staff_link])
    #
    #         el.update_attributes(staffer_date: current_time, bds_status: "Staffer Result")
    #
    #     end # cores Loop - Ends
    # end # start_staffer(ids) - Ends

    # def search(core, url)
    #     begin
    #         temp_list = [ 'DDC', 'dealeron', 'cobalt', 'DealerFire', 'di_homepage' ]
    #
    #         @agent = Mechanize.new
    #         doc = @agent.get(url)
    #         detect =  false
    #
    #         for term in temp_list
    #             if doc.at_css('head').text.include?(term)
    #                 detect = true
    #                 temp_method(term, doc, url)
    #             end
    #         end
    #
    #         unless detect
    #             core.update_attribute(:staffer_status, "Temp Error")
    #             puts "\n\n===== Template Unidentified =====\n\n"
    #         end
    #     rescue
    #         core.update_attribute(:staffer_status, "Search Error")
    #         puts "\n\n===== StafferService#search Error: #{$!.message} =====\n\n"
    #     end
    #
    #     #== Throttle (if needed) =====================
    #     throttle_delay_time = (1..2).to_a.sample
    #     puts "Completed"
    #     puts "Please wait #{throttle_delay_time} seconds."
    #     puts "--------------------------------"
    #     sleep(throttle_delay_time)
    #
    # end

    # def temp_method(term, doc, url)
    #     sc = Scrapers.new(@cols_hash)
    #     domain = @cols_hash[:domain]
    #
    #     case term
    #     when "DDC"
    #         sc.ddc_scraper(doc, url)
    #         diff_staff_url_for_ddc(sc, url, domain)
    #     when "dealeron"
    #         sc.do_scraper(doc, url)
    #     when "cobalt"
    #         sc.cobalt_scraper(doc, url)
    #     when "DealerFire"
    #         sc.df_scraper(doc, url)
    #     when "di_homepage"
    #         sc.di_scraper(doc, url)
    #     end
    # end

    # def diff_staff_url_for_ddc(scrapers_obj, url, domain)
    #     staff_url = domain + "dealership/staff.htm"
    #     if url != staff_url
    #         staff_docu = @agent.get(staff_url)
    #         scrapers_obj.ddc_scraper(staff_docu, staff_url)
    #         puts "\n\n===== Different staff url for ddc =====\n\n"
    #     end
    # end

    # def staffer_sfdc_id_cleaner
    #     cores = Core.where.not(temporary_id: nil, staff_link: nil)
    #     cores.each do |core|
    #         staffers = Staffer.where(cont_source: "Dealer Site", sfdc_id: core.temporary_id, staff_link: core.staff_link)
    #         staffers.each do |staffer|
    #             staffer.update_attribute(:sfdc_id, core.sfdc_id)
    #         end
    #     end
    # end

    # def staffer_core_updater
    #
    #     # staffers = Staffer.where(cont_source: "CRM")
    #     staffers = Staffer.all
    #     counter = 0
    #     staffers.each do |staff|
    #         cores = Core.where(sfdc_id: staff.sfdc_id)
    #         cores.each do |core|
    #
    #             ## CORES UPDATES STAFFERS ##
    #             # staff.update_attributes(sfdc_sales_person: core.sfdc_sales_person, sfdc_type: core.sfdc_type, sfdc_tier: core.sfdc_tier, acct_name: core.sfdc_acct, group_name: core.sfdc_group, ult_group_name: core.sfdc_ult_grp, franchise: core.sfdc_franch_cons, coordinates: core.coordinates, full_address: core.full_address, franch_cat: core.sfdc_franch_cat)
    #
    #             ## STAFFERS UPDATES CORES ##
    #
    #             staff_source = staff.cont_source
    #
    #             if staff_source == "Web"
    #                 staff_source = "Web Contacts"
    #
    #                 staff.update_attributes(franchise: core.sfdc_franch_cons, full_address: core.full_address, franch_cat: core.sfdc_franch_cat)
    #
    #             elsif staff_source == "CRM"
    #                 staff_source = "CRM Contacts"
    #             else
    #                 staff_source
    #             end
    #
    #             puts "---------------------------"
    #             puts "Counter: #{counter}"
    #             puts "Staff Source: #{staff_source}"
    #             puts "---------------------------"
    #             counter +=1
    #             core.update_attributes(staffer_status: staff_source, staffer_date: staff.created_at)
    #         end
    #     end
    # end ## staffer_core_updater

# end  # Ends class StafferService




class Scrapers
    def initialize(cols_hash)
        @cols_hash = cols_hash
    end



    def ddc_scraper(html, url)
        begin
            #==ACCOUNT FIELDS==ARRAYS
            selector = "//meta[@name='author']/@content"
            org = xpath_fix(html.xpath(selector))
            acc_phone = nil_fix(html.at_css('.value'))

            # ACCOUNT ADDRESS:
            street = nil_fix(html.at_css('.adr .street-address'))
            city = nil_fix(html.at_css('.adr .locality'))
            state = nil_fix(html.at_css('.adr .region'))
            zip = nil_fix(html.at_css('.adr .postal-code'))

            #==CONTACT FIELDS==ARRAYS
            full_names = empty_arr_fix(html.css('#staffList .vcard .fn'))
            jobs = empty_arr_fix(html.css('#staffList .vcard .title'))
            emails = empty_arr_fix(html.css('#staffList .vcard .email'))

            size = full_names.length
            if jobs.length != size
                n = size - jobs.length
                n.times {jobs << "N/A"} if n >= 0
            elsif emails.length != size
                n = size - emails.length
                n.times {emails << "N/A"} if n >= 0
            end

            fnames = []
            lnames = []
            full_names.each do |name|
                words = name.split(' ')
                fnames << words[0]
                lnames << words[-1]
            end

            for i in 0...size
                add_indexer_row_with("Web Contacts", "Dealer.com", org, street, city, state, zip, acc_phone, jobs[i], fnames[i], lnames[i], full_names[i], emails[i], "Web Contacts", "Dealer Site", "")
            end
        rescue
            error_indicator(url, "Dearler.com")
            puts "\n\n===== Dealer.com Error | Msg: #{$!.message} =====\n\n"
        end
    end # End of Main Method: "def ddc_scraper"


    def xpath_fix(nodeSet)  # For: ddc_scraper
        nodeSet.empty? ? "N/A" : (nodeSet.map {|n| n}).join(' ').strip
    end


    def nil_fix(element)  # For: ddc_scraper
        element.nil? ? "N/A" : element.text.strip
    end


    def empty_arr_fix(arr)  # For: ddc_scraper
        arr.empty? ? ["N/A"] : arr.map {|el| el.text.strip}
    end


    # def add_indexer_row_with(staffer_status, temp, org, street, city, state, zip, acc_phone, jobs, fnames, lnames, full_names, emails, cont_status, cont_source, influence)
    #     @cols_hash[:staffer_status] = staffer_status
    #     @cols_hash[:template] = temp
    #     @cols_hash[:acct_name] = org
    #     @cols_hash[:street] = street
    #     @cols_hash[:city] = city
    #     @cols_hash[:state] = state
    #     @cols_hash[:zip] = zip
    #     @cols_hash[:phone] = acc_phone
    #     @cols_hash[:job_raw] = jobs
    #     @cols_hash[:fname] = fnames
    #     @cols_hash[:lname] = lnames
    #     @cols_hash[:fullname] = full_names
    #     @cols_hash[:email] = emails
    #     @cols_hash[:cont_status] = cont_status
    #     @cols_hash[:cont_source] = cont_source
    #     @cols_hash[:influence] = influence
    #
    #     core = Core.find_by(sfdc_id: @cols_hash[:sfdc_id])
    #     indicator_gauge
    #
    #     Staffer.create(@cols_hash)
    #     core.update_attributes(staffer_status: staffer_status, template: temp, site_acct: org, site_street: street, site_city: city, site_state: state, site_zip: zip, site_ph: acc_phone)
    # end


    # def indicator_gauge
    #     core = Core.find_by(sfdc_id: @cols_hash[:sfdc_id])
    #
    #     core.update_attributes(
    #         acct_indicator: comparer(core.sfdc_acct, @cols_hash[:acct_name]),
    #         street_indicator: comparer(core.sfdc_street, @cols_hash[:street]),
    #         city_indicator: comparer(core.sfdc_city, @cols_hash[:city]),
    #         state_indicator: comparer(core.sfdc_state, @cols_hash[:state]),
    #         zip_indicator: comparer(core.sfdc_zip, @cols_hash[:zip]),
    #         ph_indicator: comparer(core.sfdc_ph, @cols_hash[:phone]))
    # end

    # def comparer(str1, str2)
    #     return str1 == str2 ? "same" : "different"
    # end





    def do_scraper(html, url)
        begin
            #==ACCOUNT FIELDS==ARRAYS
            org = html.at_css('.dealerName').text
            acc_phones = html.css('.callNowClass').collect {|phone| phone.text}
            acc_phones_str = acc_phones.join(', ')

            # ACCOUNT FULL ADDRESS: #=NEED TO SPLIT!!!!!!!
            addy = html.at_css('.adr').text

            #==CONTACT FIELDS==ARRAYS
            full_names = html.css('.staff-title').map {|name| name.text.strip}
            jobs = html.css('.staff-desc').map {|job| job.text.strip}
            phones = html.css('.phone1').map {|phone| phone.text.strip}
            emails = html.css('.email').map {|email| email.text.strip}

            size = full_names.length
            if jobs.length &&  phones.length && emails.length == size
                fnames = []
                lnames = []
                full_names.each {|name|
                    words = name.split(' ')
                    fnames.push(words[0])
                    lnames.push(words[-1])
                }

                for i in 0...size
                    add_indexer_row_with(["Web Contacts", "DealerOn", org, street, city, state, zip, acc_phone, jobs[i], fnames[i], lnames[i], full_names[i], emails[i], "Web Contacts", "Dealer Site", ""])
                end
            else
                error_indicator(url, "DealerOn Length")
                puts "\n\n===== Employee contact info column length error =====\n\n"
            end
        rescue
            error_indicator(url, "DearlOn")
            puts "\n\n===== DealerOn Error | Msg: #{$!.message} =====\n\n"
        end
    end # End of Main Method: "def do_scraper"


    def cobalt_scraper(html, url)   # Problems w/ cobalt_verify below
        begin
            #==ACCOUNT FIELDS==ARRAYS
            org_sel = "//img[@class='cblt-lazy']/@alt"
            org = html.xpath(org_sel)
            if org.empty?
                org = "Not Found"
            end
            acc_phone = html.css('.CONTACTUsInfo').text

            # ACCOUNT FULL ADDRESS: # ONE SINGLE ADDRESS STRING
            selector = "//a[@href='HoursAndDirections']"
            street = html.xpath(selector).text
            city = ''
            state = ''
            zip = ''

            #==CONTACT FIELDS==ARRAYS
            full_names = html.css('.contact-name').map {|name| name.text.strip}
            jobs = html.css('.contact-title').map {|job| job.text.strip}
            emails = html.css('.contact-email').map {|email| email.text.strip}

            size = full_names.length
            if jobs.length && emails.length == size
                fnames = []
                lnames = []
                full_names.each {|name|
                    words = name.split(' ')
                    fnames.push(words[0])
                    lnames.push(words[-1])
                }

                for i in 0...size
                    add_indexer_row_with(["Web Contacts", "Cobalt", org, street, city, state, zip, acc_phone, jobs[i], fnames[i], lnames[i], full_names[i], emails[i], "Web Contacts", "Dealer Site", ""])
                end

            else
                error_indicator(url, "Cobalt Length")
                puts "\n\n===== Employee contact info column length error =====\n\n"
            end
        rescue
            error_indicator(url, "Cobalt")
            puts "\n\n===== Cobalt Error | Msg: #{$!.message} =====\n\n"
        end
    end # End of Main Method: "def cobalt_scraper"


    def drop_comma(str)  # For: DealerFire
        if str.include?(',')
            str.delete(',')
        else
            str
        end
    end


    def match_arr(size, array)  # For: DealerFire
        if array.length != size
            n = size - array.length
            n.times {|i| array.push('NOT MATCHED')}
        end
        return array
    end


    def df_scraper(html, url)   # Problem w/ email
        begin
            #==ACCOUNT FIELDS==ARRAYS
            org = html.at_css('.foot-thanks h1').text
            acc_phones = html.css('#salesphone').collect {|phone| phone.text}
            acc_phones_str = acc_phones.join(', ')

            # ACCOUNT FULL ADDRESS:
            addy = html.at_css('.hide-address').text.split(' ')
            street = addy[0..-4].join(' ')
            city = drop_comma(addy[-3])
            state = drop_comma(addy[-2])
            zip = addy[-1]

            #==CONTACT FIELDS==ARRAYS
            full_names = html.css('.fn').map {|name| name.text.strip}
            jobs = html.css('.position').map {|job| job.text.strip}
            phones = html.css('.tel').map {|phone| phone.text.strip}
            selector = "//meta[@itemprop='email']/@content"
            nodes = html.xpath(selector)
            emails = nodes.map {|n| n}

            size = full_names.length
            if jobs.length == size
                match_arr(size, phones)
                match_arr(size, emails)

                fnames = []
                lnames = []
                full_names.each {|name|
                    words = name.split(' ')
                    fnames.push(words[0])
                    lnames.push(words[-1])
                }

                for i in 0...size
                    add_indexer_row_with(["Web Contacts", "DealerFire", org, street, city, state, zip, acc_phone, jobs[i], fnames[i], lnames[i], full_names[i], emails[i], "Web Contacts", "Dealer Site", ""])
                end
            else
                error_indicator(url, "DealerFire Length")
                puts "\n\n===== Employee contact info column length error =====\n\n"
            end
        rescue
            error_indicator(url, "DealerFire")
            puts "\n\n===== DealerFire Error | Msg: #{$!.message} =====\n\n"
        end
    end # End of Main Method: "def df_scraper"


    def di_scraper(html, url)
        begin
            #==ACCOUNT FIELDS==ARRAYS
            org = html.at_css('.organization-name').text
            acc_phones = html.css('.tel').collect {|phone| phone.text}
            acc_phones_str = acc_phones.join(', ')

            # ACCOUNT ADDRESS:
            street = html.at_css('.street-address').text
            city = html.at_css('.locality').text
            state = html.at_css('.region').text
            zip = html.at_css('.postal-code').text

            #==CONTACT FIELDS==ARRAYS
            full_names = []  # BEGIN NAMES ARRAY
            html.css('.staff-item h3').map {|name|
                unless full_names.include?(name.text.strip)
                    full_names.push(name.text.strip)
                end
            } # END NAMES

            jobs = []  # BEGIN JOBS ARRAY
            html.css('.staff-item h4').map {|job|
                unless jobs.include?(job.text.strip)
                    jobs.push(job.text.strip)
                end
            }  # END JOBS ARRAY

            phones = html.css('.staffphone').map {|phone| phone.text.strip}

            # EMAILS BELOW
            selector = "//a[starts-with(@href, 'mailto:')]/@href"
            nodes = html.xpath(selector)
            emails =  nodes.collect {|n| n.value[7..-1]}
            # END EMAILS

            size = full_names.length
            if jobs.length &&  phones.length && emails.length == size
                fnames = []
                lnames = []
                full_names.each {|name|
                    words = name.split(' ')
                    fnames.push(words[0])
                    lnames.push(words[-1])
                }

                for i in 0...size
                    add_indexer_row_with(["Web Contacts", "DealerInspire", org, street, city, state, zip, acc_phone, jobs[i], fnames[i], lnames[i], full_names[i], emails[i], "Web Contacts", "Dealer Site", ""])
                end
            else
                error_indicator(url, "DealerInspire Length")
                puts "\n\n===== Employee contact info column length error =====\n\n"
            end
        rescue
            error_indicator(url, "DealerInspire")
            puts "\n\n===== DealerInspire Error | Msg: #{$!.message} =====\n\n"
        end
    end # End of Main Method: "def di_scraper"



    def error_indicator(url, temp_name)
        core = Core.find_by(staff_link: url)
        core.update_attribute(:staffer_status, "#{temp_name} Error")
    end


end  # Ends class Scrapers
