require 'mechanize'
require 'nokogiri'
require 'open-uri'
# require_relative 'staffer_service_helper'

class StafferService

###########################################
###  SCRAPER METHODS: contact_data_getter ~ STARTS
###########################################

    def cs_data_getter

        a=20
        z=25
        # a=500
        # z=1000
        # a=1000
        # z=-1

        ###### GENERAL
        # indexers = Indexer.where(template: "DealerCar Search")[a...z]
        # indexers = Indexer.where(template: "Dealer Direct")[a...z]
        # indexers = Indexer.where(template: "DealerOn")[a...z]  ##852
        # indexers = Indexer.where(template: "Dealer Inspire")[a...z]
        # indexers = Indexer.where(template: "DealerFire")[a...z]
        # indexers = Indexer.where(template: "DEALER eProcess")[a...z]


        ###### DealerCar Search STAFF PAGE
        # indexers = Indexer.where(template: "DealerCar Search")[a...z]
        # indexers = Indexer.where(clean_url: "here")


        ###### DealerFire STAFF PAGE
        # indexers = Indexer.where(template: "DealerFire")[a...z]
        # indexers = Indexer.where(clean_url: "http://www.donjacobsvolkswagen.com")
        # indexers = Indexer.where(clean_url: "http://www.weslacoford.com")
        # indexers = Indexer.where(clean_url: "http://www.palmen.com")
        # indexers = Indexer.where(clean_url: "http://www.cochranvwnorth.com")
        # indexers = Indexer.where(clean_url: "http://www.perrymotorshonda.com")
        # indexers = Indexer.where(clean_url: "http://www.jcbillionnissan.com")

        # http://www.donjacobsvolkswagen.com/team-don-jacobs-volkswagen-in-lexington-ky
        # http://www.weslacoford.com/team-payne-weslaco-ford-in-weslaco-tx
        # http://www.palmen.com/team-palmen-in-racine-kenosha-wi
        # http://www.cochranvwnorth.com/team-volkswagen-north-hills-in-wexford-pa
        # http://www.perrymotorshonda.com/team-perry-honda-in-bishop-ca
        # http://www.jcbillionnissan.com/team-jc-billion-nissan-in-bozeman-mt
        #OUR TEAM


        ###### Cobalt STAFF PAGE
        ### (HELP!!) ### DIFFERENT CSS CLASS NAMES for Email / Phone.
        ### MULTIPLE URL EXTENSIONS FOR STAFF PAGE.
        # indexers = Indexer.where(template: "Cobalt")[a...z] #3792
        # indexers = Indexer.where(clean_url: "http://www.shireycadillacgm.com")  ## /MeetOurDepartments
        # indexers = Indexer.where(clean_url: "http://www.nissanmarin.com")  ## /MeetOurDepartments
        # indexers = Indexer.where(clean_url: "http://www.irwinautoco.com")  ## /MeetOurDepartments
        # indexers = Indexer.where(clean_url: "http://www.jcharriscadillac.com")  ## /MeetOurDepartments
        # indexers = Indexer.where(clean_url: "http://www.chasechevroletstockton.com")  ## /MeetOurDepartments

        # http://www.lexusgwinnett.com/Meet-Our-Staff
        # http://www.vivachevy.com/MeetOurStaff
        # /MeetOurDepartments
        # /MeetOurStaff
        # /Meet-Our-Staff
        # /Staff

        # MEET OUR TEAM
        # MEET OUR STAFF
        # MEET THE STAFF


        ###### DEALER eProcess STAFF PAGE
        ### (HELP!!) ### DIFFERENT CSS CLASS NAMES.
        # indexers = Indexer.where(template: "DEALER eProcess")[a...z]
        # indexers = Indexer.where(clean_url: "http://www.mazdaofclearlake.com")
        # indexers = Indexer.where(clean_url: "http://www.karitoyota.com") # not working
        # indexers = Indexer.where(clean_url: "http://www.usedcarnh.net") # not working
        # indexers = Indexer.where(clean_url: "http://www.rrmcsterling.com")
        # indexers = Indexer.where(clean_url: "http://www.alohakiaairport.com") # dups
        # indexers = Indexer.where(clean_url: "http://www.joecooperfordtulsa.com") # not working
        # indexers = Indexer.where(clean_url: "http://www.valenciaacura.com") # not working
        # indexers = Indexer.where(clean_url: "http://www.lumsautocenter.com")
        # indexers = Indexer.where(clean_url: "http://www.harrisisuzu.com")

        indexers = Indexer.where(clean_url: %w(http://www.karitoyota.com http://www.usedcarnh.net http://www.rrmcsterling.com http://www.alohakiaairport.com http://www.joecooperfordtulsa.com http://www.valenciaacura.com http://www.lumsautocenter.com http://www.harrisisuzu.com))
        # /meet-our-staff/


        ###### Dealer Inspire STAFF PAGE
        ### (HELP!!) ### DUPLICATE DATA B/C FLUID AND STATIC VERSION.
        # indexers = Indexer.where(template: "Dealer Inspire")[a...z]
        # indexers = Indexer.where(clean_url: "http://www.garberbuickgmc.com")  ## /about-us/staff/
        # indexers = Indexer.where(clean_url: "http://www.fiatoftacoma.com")  ## /about-us/staff/
        # indexers = Indexer.where(clean_url: "http://www.commonwealthhonda.com")  ## /about-us/staff/

        # http://www.clevelandmotorsports.com/about-us/meet-our-staff/
        # https://www.palmerstoyota.com/about-us/meet-our-staff/
        # https://www.pretoy.com/team/
        # http://www.landroverpalmbeach.com/staff/

        # http://www.clevelandmotorsports.com/about-us/meet-our-staff/
        # https://www.palmerstoyota.com/about-us/meet-our-staff/
        # https://www.pretoy.com/team/
        # http://www.landroverpalmbeach.com/staff/

        # MEET OUR STAFF
        # Meet Our Staff
        # MEET OUR TEAM
        # OUR TEAM


        ###### (*DONE!) DEALER.com STAFF PAGE
        # indexers = Indexer.where(template: "Dealer.com")[a...z]
        # indexers = Indexer.where(clean_url: "http://www.bobbellford.net")
        # indexers = Indexer.where(clean_url: "http://www.norrishonda.com")
        # indexers = Indexer.where(clean_url: "http://www.hallmarkvw.com")
        # indexers = Indexer.where(clean_url: "http://www.fairoaksmotors.com")

        ###### (*DONE!)  Dealer Direct STAFF PAGE
        # indexers = Indexer.where(template: "Dealer Direct")[a...z]
        # indexers = Indexer.where(clean_url: "http://www.larrygewekeford.net")
        # indexers = Indexer.where(clean_url: "http://www.thinkfullerford.com")
        # indexers = Indexer.where(clean_url: "http://www.acrivelliford.com")
        # indexers = Indexer.where(clean_url: "http://www.midwayfordtruck.com")
        # indexers = Indexer.where(clean_url: "http://www.kelleher-ford.com")
        # indexers = Indexer.where(clean_url: "http://www.dovecreekford.com")
        # indexers = Indexer.where(clean_url: "http://www.salesfordlincoln.com")
        # indexers = Indexer.where(clean_url: "http://www.boeckmanford.net")
        # indexers = Indexer.where(clean_url: "http://milwaukeeford.com")

        ###### (*DONE!) DealerOn STAFF PAGE
        # indexers = Indexer.where(template: "DealerOn")[a...z]
        # indexers = Indexer.where(clean_url: "http://www.vwmankato.com")
        # indexers = Indexer.where(clean_url: "http://www.laurelkia.com")
        # indexers = Indexer.where(clean_url: "http://www.dalehoward.com")
        # indexers = Indexer.where(clean_url: "http://www.porscheofranchomirage.com")
        # indexers = Indexer.where(clean_url: "http://www.borcherding.com")
        # indexers = Indexer.where(clean_url: "http://www.mywhalingcity.com")
        # /staff.aspx


        counter=0
        range = z-a
        indexers.each do |indexer|
            template = indexer.template
            clean_url = indexer.clean_url

            case template
            when "Dealer.com"
                url = "#{clean_url}/dealership/staff.htm"
            when "DealerOn"
                url = "#{clean_url}/staff.aspx"
            when "Cobalt"
                url = "#{clean_url}/MeetOurDepartments"
                # url = "#{clean_url}/MeetOurStaff/staff.htm"
                # url = "#{clean_url}/Meet-Our-Staff/staff.htm"
                # url = "#{clean_url}/Staff/staff.htm"
                # url = "#{clean_url}/dealership/staff.htm"
            when "Dealer Direct"
                url = "#{clean_url}/staff"
            when "Dealer Inspire"
                url = "#{clean_url}/about-us/staff/"
                # url = "#{clean_url}/team/"
                # url = "#{clean_url}/staff/"
            when "DealerFire"
                # url = "#{clean_url}/team-don-jacobs-volkswagen-in-lexington-ky"
                # url = "#{clean_url}/team-payne-weslaco-ford-in-weslaco-tx"
                # url = "#{clean_url}/team-palmen-in-racine-kenosha-wi"
                # url = "#{clean_url}/team-volkswagen-north-hills-in-wexford-pa"
                # url = "#{clean_url}/team-perry-honda-in-bishop-ca"
                url = "#{clean_url}/team-jc-billion-nissan-in-bozeman-mt"
            when "DEALER eProcess"
                url = "#{clean_url}/meet-our-staff"
            when "DealerCar Search"
                # url = "#{clean_url}/"
            end

            counter+=1
            puts "\n============================\n"
            puts "[#{a}...#{z}]  (#{counter}/#{range})"

            begin
                @agent = Mechanize.new
                html = @agent.get(url)


                case template
                when "Dealer.com"
                    dealer_com_cs(html, url, indexer)
                when "Cobalt"
                    cobalt_cs(html, url, indexer)
                when "DealerOn"
                    dealeron_cs(html, url, indexer)
                when "DealerCar Search"
                    dealercar_search_cs(html, url, indexer)
                when "Dealer Direct"
                    dealer_direct_cs(html, url, indexer)
                when "Dealer Inspire"
                    dealer_inspire_cs(html, url, indexer)
                when "DealerFire"
                    dealerfire_cs(html, url, indexer)
                when "DEALER eProcess"
                    dealer_eprocess_cs(html, url, indexer)
                end


            rescue
                error = $!.message
                error_msg = "RT Error: #{error}"
                if error_msg.include?("connection refused")
                    cs_error_code = "Connection Error"
                elsif error_msg.include?("undefined method")
                    cs_error_code = "Method Error"
                elsif error_msg.include?("404 => Net::HTTPNotFound")
                    cs_error_code = "404 Error"
                elsif error_msg.include?("TCP connection")
                    cs_error_code = "TCP Error"
                else
                    cs_error_code = error_msg
                end
                puts "\n\n>>> #{error_msg} <<<\n\n"

                # indexer.update_attributes(indexer_status: "CS Error", cs_sts: cs_error_code)
            end ## rescue ends

            sleep(3)
        end ## .each loop ends

    end



    # Duplicate Old Version!!!
    # def dealer_eprocess_cs(html, url, indexer) ### NEED HELP!
    #     ### (HELP!!) ### DIFFERENT CSS CLASS NAMES.
    #     puts indexer.template
    #     puts url
    #     puts
    #
    #     # html.css('.employee_name').text
    #     # html.css('.employee_title').text
    #     # html.css('.employee_email').text
    #     # html.css('.dept_number').text
    #
    #     full_names = html.css('.employee_name').text.strip if html.css('.employee_name')
    #     full_names = html.css('.employee_name_staff').text.strip if full_names.blank? && html.css('.employee_name_staff')
    #
    #     if !full_names.blank?
    #
    #         # jobs = html.css('.employee_title').text.strip if html.css('.employee_title')
    #         # jobs = html.css('.employee_title_staff').text.strip if jobs.blank? && html.css('.employee_title_staff')
    #         #
    #         # emails = html.css('.employee_email').text.strip if html.css('.employee_email')
    #         # emails = html.css('.employee_link_staff').text.strip if emails.blank? && html.css('.employee_link_staff')
    #         #
    #         # phones = html.css('.dept_number').text.strip if html.css('.dept_number')
    #         # phones = html.css('.employee_info').text.strip if phones.blank? && html.css('.employee_info')
    #
    #
    #         staff_count = full_names.length
    #         puts "staff_count: #{staff_count}"
    #         staff_hash_array = []
    #
    #         for i in 0...staff_count
    #             staff_hash = {}
    #
    #             staff_hash[:full_name] = html.css('.employee_name')[i].text.strip if html.css('.employee_name')[i]
    #             staff_hash[:full_name] = html.css('.employee_name_staff')[i].text.strip if html.css('.employee_name_staff')[i]
    #             staff_hash[:job] = html.css('.employee_title')[i].text.strip if html.css('.employee_title')[i]
    #             staff_hash[:job] = html.css('.employee_title_staff')[i].text.strip if html.css('.employee_title_staff')[i]
    #             staff_hash[:email] = html.css('.employee_email')[i].text.strip if html.css('.employee_email')[i]
    #             staff_hash[:phone] = html.css('.dept_number')[0].text.strip if html.css('.dept_number')
    #
    #
    #             # staff_hash[:full_name] = full_names
    #             # staff_hash[:job] = jobs
    #             # staff_hash[:emails] = emails
    #             # staff_hash[:phones] = phones
    #
    #
    #             staff_hash_array << staff_hash
    #         end
    #
    #         puts "staff_hash_array: #{staff_hash_array}"
    #
    #         staff_hash_array.each do |hash|
    #             puts
    #             hash.each do |key, value|
    #                 puts "#{key}: #{value.inspect}"
    #             end
    #         end
    #         puts "-------------------------------"
    #
    #         staff_hash_array
    #     end
    #
    #
    #     #
    #     # if html.css('.employee_name')
    #     #     staff_count = html.css('.employee_name').count
    #     #     puts "staff_count: #{staff_count}"
    #     #     staff_hash_array = []
    #     #
    #     #     for i in 0...staff_count
    #     #         staff_hash = {}
    #     #         staff_hash[:full_name] = html.css('.employee_name')[i].text.strip
    #     #         staff_hash[:job] = html.css('.employee_title')[i] ? html.css('.employee_title')[i].text.strip : ""
    #     #         staff_hash[:email] = html.css('.employee_email')[i] ? html.css('.employee_email')[i].text.strip : ""
    #     #         staff_hash[:phone] = html.css('.dept_number')[0] ? html.css('.dept_number')[0].text.strip : ""
    #     #
    #     #         staff_hash_array << staff_hash
    #     #     end
    #     #
    #     #     puts "staff_hash_array: #{staff_hash_array}"
    #     #
    #     #     staff_hash_array.each do |hash|
    #     #         puts
    #     #         hash.each do |key, value|
    #     #             puts "#{key}: #{value.inspect}"
    #     #         end
    #     #     end
    #     #     puts "-------------------------------"
    #     #
    #     #     staff_hash_array
    #     # end
    #
    #     # binding.pry
    #
    #     # cs_formatter(fname, lname, fullname, title, email)
    # end



    def dealer_eprocess_cs(html, url, indexer) ### NEED HELP!
        ### (HELP!!) ### DIFFERENT CSS CLASS NAMES.
        # puts indexer.template
        # puts url
        # puts

        staffs = html.css(".employee_wrap")
        staff_hash_array = []

        staffs.each do |staff|
            staff_hash = {}
            # Get name, job, phone
            info_ori = staff.text.split("\n").map {|el| el.delete("\t") }
            infos = info_ori.delete_if {|el| el.blank?}

            names = html.css(".employee_name").text
            jobs = html.css(".employee_title").text

            infos.each do |info|
                num_reg = Regexp.new("[0-9]+")
                if jobs.include?(info)
                    staff_hash[:job] = info
                elsif names.include?(info)
                    staff_hash[:full_name] = info
                elsif num_reg.match(info) && info.length < 17
                    staff_hash[:phone] = info
                end
            end

            # Get email
            data = staff.inner_html
            regex = Regexp.new("[a-z]+[@][a-z]+[.][a-z]+")
            email_reg = regex.match(data)
            staff_hash[:email] = email_reg.to_s if email_reg

            staff_hash_array << staff_hash
        end

        # staff_hash_array.each do |hash|
        #     puts
        #     hash.each do |key, value|
        #         puts "#{key}: #{value.inspect}"
        #     end
        #     puts "-------------------------------"
        # end

        print_result(indexer.template, url, staff_hash_array)

        prep_create_staffer(staff_hash_array)

        # html.css('.employee_name').text
        # html.css('.employee_title').text
        # html.css('.employee_email').text
        # html.css('.dept_number').text
        #
        # full_names = html.css('.employee_name').text.strip if html.css('.employee_name')
        # full_names = html.css('.employee_name_staff').text.strip if full_names.blank? && html.css('.employee_name_staff')
        #
        # if !full_names.blank?
        #
        #     # jobs = html.css('.employee_title').text.strip if html.css('.employee_title')
        #     # jobs = html.css('.employee_title_staff').text.strip if jobs.blank? && html.css('.employee_title_staff')
        #     #
        #     # emails = html.css('.employee_email').text.strip if html.css('.employee_email')
        #     # emails = html.css('.employee_link_staff').text.strip if emails.blank? && html.css('.employee_link_staff')
        #     #
        #     # phones = html.css('.dept_number').text.strip if html.css('.dept_number')
        #     # phones = html.css('.employee_info').text.strip if phones.blank? && html.css('.employee_info')
        #
        #
        #     staff_count = full_names.length
        #     puts "staff_count: #{staff_count}"
        #     staff_hash_array = []
        #
        #     for i in 0...staff_count
        #         staff_hash = {}
        #
        #         staff_hash[:full_name] = html.css('.employee_name')[i].text.strip if html.css('.employee_name')[i]
        #         staff_hash[:full_name] = html.css('.employee_name_staff')[i].text.strip if html.css('.employee_name_staff')[i]
        #         staff_hash[:job] = html.css('.employee_title')[i].text.strip if html.css('.employee_title')[i]
        #         staff_hash[:job] = html.css('.employee_title_staff')[i].text.strip if html.css('.employee_title_staff')[i]
        #         staff_hash[:email] = html.css('.employee_email')[i].text.strip if html.css('.employee_email')[i]
        #         staff_hash[:phone] = html.css('.dept_number')[0].text.strip if html.css('.dept_number')
        #
        #
        #         # staff_hash[:full_name] = full_names
        #         # staff_hash[:job] = jobs
        #         # staff_hash[:emails] = emails
        #         # staff_hash[:phones] = phones
        #
        #
        #         staff_hash_array << staff_hash
        #     end
        #
        #     puts "staff_hash_array: #{staff_hash_array}"
        #
        #     staff_hash_array.each do |hash|
        #         puts
        #         hash.each do |key, value|
        #             puts "#{key}: #{value.inspect}"
        #         end
        #     end
        #     puts "-------------------------------"
        #
        #     staff_hash_array
        # end
    end





    def dealerfire_cs(html, url, indexer)
        puts indexer.template
        puts url
        puts
        staffs = html.xpath("//div[@class='staffs-list']/div[@itemprop='employees']")
        staff_hash_array = []

        staffs.each do |staff|
            staff_hash = {}
            # Get name, job, phone
            info_ori = staff.text.split("\n").map {|el| el.delete("\t") }
            infos = info_ori.delete_if {|el| el.blank?}

            jobs = html.css("[@itemprop='jobTitle']").text
            names = html.css("[@itemprop='name']").text

            infos.each do |info|
                num_reg = Regexp.new("[0-9]+")
                if jobs.include?(info)
                    staff_hash[:job] = info
                elsif names.include?(info)
                    staff_hash[:full_name] = info
                elsif num_reg.match(info)
                    staff_hash[:phone] = info
                end
            end

            # Get email
            data = staff.inner_html
            regex = Regexp.new("[a-z]+[@][a-z]+[.][a-z]+")
            email_reg = regex.match(data)
            staff_hash[:email] = email_reg.to_s if email_reg

            staff_hash_array << staff_hash
            puts "-------------------------------"
        end

        staff_hash_array.each do |hash|
            puts
            hash.each do |key, value|
                puts "#{key}: #{value.inspect}"
            end
        end

        prep_create_staffer(staff_hash_array)
    end








    def dealer_inspire_cs(html, url, indexer)  ### NEED HELP!
        ### HELP - emails not matching at bottom of page.
        # http://www.garberbuickgmc.com/about-us/staff/
        # http://www.fiatoftacoma.com/about-us/staff/
        puts indexer.template
        puts url
        puts

        if html.css('.staff-bio h3')
            staff_count = html.css('.staff-bio h3').count
            puts "staff_count: #{staff_count}"
            staff_hash_array = []

            for i in 0...staff_count
                staff_hash = {}
                # staff_hash[:full_name] = html.xpath("//a[starts-with(@href, 'mailto:')]/@data-staff-name")[i].value
                # staff_hash[:job] = html.xpath("//a[starts-with(@href, 'mailto:')]/@data-staff-title") ? html.xpath("//a[starts-with(@href, 'mailto:')]/@data-staff-title")[i].value : ""
                staff_hash[:full_name] = html.css('.staff-bio h3')[i] ? html.css('.staff-bio h3')[i].text.strip : ""
                staff_hash[:job] = html.css('.staff-bio h4')[i] ? html.css('.staff-bio h4')[i].text.strip : ""

                staff_hash[:email] = html.css('.staff-email-button')[i] ? html.css('.staff-email-button')[i].attributes["href"].text : ""

                # staff_hash[:email] = html.css('.staff-email-button')[i].attributes["href"] ? html.css('.staff-email-button')[i].attributes["href"].text : ""


                staff_hash[:phone] = html.css('.staffphone')[i] ? html.css('.staffphone')[i].text.strip : ""

                staff_hash_array << staff_hash
            end

            puts "staff_hash_array: #{staff_hash_array}"

            staff_hash_array.each do |hash|
                puts
                hash.each do |key, value|
                    puts "#{key}: #{value.inspect}"
                end
            end
            puts "-------------------------------"

            staff_hash_array
        end

        prep_create_staffer(staff_hash_array)
    end



    def cobalt_cs(html, url, indexer) ### Perfect, except for phone numbers not matching.
        ### Perfect, except for phone numbers not matching.

        staffs = html.css("[@itemprop='employee']")
        staff_hash_array = []

        puts "count: #{staffs.count}, url: #{url}"

        for i in 0...staffs.count
            staff_hash = {}
            staff_str = staffs[i].inner_html

            staff_hash[:fname] = html.css('span[@itemprop="givenName"]')[i].text.strip if html.css('span[@itemprop="givenName"]')[i]
            staff_hash[:lname] = html.css('span[@itemprop="familyName"]')[i].text.strip if html.css('span[@itemprop="familyName"]')[i]
            staff_hash[:job]   = html.css('[@itemprop="jobTitle"]')[i].text.strip   if html.css('[@itemprop="jobTitle"]')[i]

            regex = Regexp.new("[a-z]+[@][a-z]+[.][a-z]+")
            matched_email = regex.match(staff_str)
            staff_hash[:email] = matched_email.to_s if matched_email

            # Should find a common class within contact profile area.
            staff_hash[:ph1] = html.css('span[@itemprop="telephone"]')[i].text.strip if html.css('span[@itemprop="telephone"]')[i]
            staff_hash[:ph2] = html.css('.link [@itemprop="telephone"]')[i].text.strip if html.css('.link [@itemprop="telephone"]')[i]

            staff_hash_array << staff_hash
        end

        puts "staff_hash_array: #{staff_hash_array}"

        staff_hash_array.each do |hash|
            puts
            hash.each do |key, value|
                puts "#{key}: #{value.inspect}"
            end
            puts "-------------------------------"
        end

        prep_create_staffer(staff_hash_array)
    end


    def dealer_direct_cs(html, url, indexer) ### DONE!
        puts indexer.template
        puts url
        puts

        if html.css('.staff-desc .staff-name')
            staff_count = html.css('.staff-desc .staff-name').count
            puts "staff_count: #{staff_count}"
            staff_hash_array = []

            for i in 0...staff_count
                staff_hash = {}
                staff_hash[:full_name] = html.css('.staff-desc .staff-name')[i].text.strip
                staff_hash[:job] = html.css('.staff-desc .staff-title')[i] ? html.css('.staff-desc .staff-title')[i].text.strip : ""
                staff_hash[:email] = html.css('.staff-info .staff-email a')[i] ? html.css('.staff-info .staff-email a')[i].text.strip : ""
                staff_hash[:phone] = html.css('.staff-info .staff-tel')[i] ? html.css('.staff-info .staff-tel')[i].text.strip : ""

                staff_hash_array << staff_hash
            end

            puts "staff_hash_array: #{staff_hash_array}"

            staff_hash_array.each do |hash|
                puts
                hash.each do |key, value|
                    puts "#{key}: #{value.inspect}"
                end
            end
            puts "-------------------------------"

            staff_hash_array
        end

        prep_create_staffer(staff_hash_array)
    end


    def dealeron_cs(html, url, indexer) ### DONE!
        ### (*Done!!) ###
        puts indexer.template
        puts url
        puts
        staff_hash_array = []

        if html.css('.staff-row .staff-title')
            staff_count = html.css('.staff-row .staff-title').count
            puts "staff_count: #{staff_count}"
            staffs = html.css(".staff-contact")

            for i in 0...staff_count
                staff_hash = {}
                staff_hash[:full_name] = html.css('.staff-row .staff-title')[i].text.strip
                staff_hash[:job] = html.css('.staff-desc')[i] ? html.css('.staff-desc')[i].text.strip : ""

                ph_email_hash = ph_email_scraper(staffs[i])
                staff_hash[:phone] = ph_email_hash[:phone]
                staff_hash[:email] = ph_email_hash[:email]

                staff_hash_array << staff_hash
            end

            puts "staff_hash_array: #{staff_hash_array}"

            staff_hash_array.each do |hash|
                hash.each do |key, value|
                    puts "#{key}: #{value.inspect}"
                end
                puts "---------------------------------------------"
            end
        end

        prep_create_staffer(staff_hash_array)
    end

    def ph_email_scraper(staff)
        ## Designed to work with dealeron_cs for when phone and email tags are missing on template, which creates mis-aligned data results.
        info = {}
        return info unless staff.children[1] || staff.children[3] # children[2] has no valuable data.

        value_1 = staff.children[1].attributes["href"].value if staff.children[1]
        value_3 = staff.children[3].attributes["href"].value if staff.children[3]

        if value_1 && value_1.include?("tel:")
            info[:phone] = value_1
        elsif value_1 && value_1.include?("mailto:")
            info[:email] = value_1
        end

        if value_3 && value_3.include?("tel:")
            info[:phone] = value_3
        elsif value_3 && value_3.include?("mailto:")
            info[:email] = value_3
        end
        info
    end


    def dealer_com_cs(html, url, indexer) ### DONE!
        puts indexer.template
        puts url
        puts

        if html.css('#staffList .vcard .fn')
            staff_count = html.css('#staffList .vcard .fn').count
            puts "staff_count: #{staff_count}"
            staff_hash_array = []

            for i in 0...staff_count
                staff_hash = {}
                staff_hash[:full_name] = html.css('#staffList .vcard .fn')[i].text.strip
                staff_hash[:job] = html.css('#staffList .vcard .title') ? html.css('#staffList .vcard .title')[i].text.strip : ""
                staff_hash[:email] = html.css('#staffList .vcard .email') ? html.css('#staffList .vcard .email')[i].text.strip : ""
                staff_hash[:phone] = html.css('#staffList .vcard .phone') ? html.css('#staffList .vcard .phone')[i].text.strip : ""
                staff_hash_array << staff_hash
            end

            puts "staff_hash_array: #{staff_hash_array}"

            staff_hash_array.each do |hash|
                puts
                hash.each do |key, value|
                    puts "#{key}: #{value.inspect}"
                end
            end
            puts "-------------------------------"

            staff_hash_array
        end

        prep_create_staffer(staff_hash_array)
    end


    def dealercar_search_cs(html, url, indexer)
        ## Not Scraping - Junk
        puts indexer.template
        puts url
        puts
        staffs = html.xpath("//div[@class='staffs-list']/div[@itemprop='employees']")
        staff_hash_array = []
        # name = info.split("itemprop=\"name\">")[1].split("</div>")[0]
        # job = info.split("itemprop=\"jobTitle\">")[1].split("</div>")[0]
        # email = info.split("itemprop=\"email\">")[1].split("</div>")[0]

        staffs.each do |staff|
            staff_hash = {}
            # Get name, job, phone
            info_ori = staff.text.split("\n").map {|el| el.delete("\t") }
            infos = info_ori.delete_if {|el| el.blank?}

            jobs = html.css("[@itemprop='jobTitle']").text
            names = html.css("[@itemprop='name']").text

            infos.each do |info|
                num_reg = Regexp.new("[0-9]+")
                if jobs.include?(info)
                    staff_hash[:job] = info
                elsif names.include?(info)
                    staff_hash[:full_name] = info
                elsif num_reg.match(info)
                    staff_hash[:phone] = info
                end
            end

            # Get email
            data = staff.inner_html
            regex = Regexp.new("[a-z]+[@][a-z]+[.][a-z]+")
            email_reg = regex.match(data)
            staff_hash[:email] = email_reg.to_s if email_reg

            staff_hash_array << staff_hash
        end

        staff_hash_array.each do |hash|
            puts
            hash.each do |key, value|
                puts "#{key}: #{value.inspect}"
            end
        end

        prep_create_staffer(staff_hash_array)
    end

    def print_result(template, url, hash_array)
        puts "\ntemplate: #{template}\nurl: #{url}\n\n"
        hash_array.each do |hash|
            hash.each do |key, value|
                puts "#{key}: #{value.inspect}"
            end
            puts "-------------------------------"
        end
    end

    def prep_create_staffer(staff_hash_array)
        staff_hash_array.each do |staff_hash|
            name_parts = staff_hash[:full_name].split(" ")
            staff_hash[:fname] = name_parts[0]
            staff_hash[:lname] = name_parts[-1]
        end
        create_staffer(staff_hash_array)
    end

    def create_staffer(staff_hash_array)
        staff_hash_array.each do |staff_hash|
            full_name = staff_hash[:full_name] ? staff_hash[:full_name] : staff_hash[:fname] + " " + staff_hash[:lname]
            # Staffer.create(
            #     fname:    staff_hash[:fname],
            #     lname:    staff_hash[:lname],
            #     fullname: full_name,
            #     job:      staff_hash[:job],
            #     phone:    staff_hash[:phone],
            #     email:    staff_hash[:email]
            # )
        end
    end



    ###############################################
    ### CS PROCESSING METHODS ~ BEGIN (ALL TEMPLATES USE THESE!!!)
    ###############################################
    def cs_formatter(fname, lname, fullname, title, email)
        ### USED FOR ALL TEMPLATES
        ### STRIPS AND FORMATS DATA BEFORE SAVING TO DB

        cs_results_processor(fname, lname, fullname, title, email)
    end


    def cs_results_processor(fname, lname, fullname, title, email)
        ### USED FOR ALL TEMPLATES
        if fname || lname || fullname || title || email
            puts indexer.template
            puts "#{url} \n\nSC Result - Success!\n\n"
            fname.nil? ? (puts "fname: nil") : (p "fname: #{fname}")
            lname.nil? ? (puts "lname: nil") : (p "lname: #{lname}")
            fullname.nil? ? (puts "fullname: nil") : (p "fullname: #{fullname}")
            title.nil? ? (puts "title: nil") : (p "title: #{title}")
            email.nil? ? (puts "email: nil") : (p "email: #{email}")
            # need to create table row / send results to db
            # indexer.update_attributes(indexer_status: "CS Result", cs_sts: CS Result)
        else
            puts "#{url} \n\nCS No-Result - Check Template Version!\n\n"
            # need to create table row / send results to db
            # indexer.update_attributes(indexer_status: "CS Result", cs_sts: CS Result)
        end

        puts "\n============================\n\n"
    end

    ###  SCRAPER METHODS: cs_results_processor ~ ENDS

    ###########################################
    ###### CS HELPER METHODS ~ ENDS #######
    ###########################################


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

end  # Ends class StafferService




class Scrapers
    def initialize(cols_hash)
        @cols_hash = cols_hash
    end



    # def ddc_scraper(html, url)
        # begin
            # #==ACCOUNT FIELDS==ARRAYS
            # selector = "//meta[@name='author']/@content"
            # org = xpath_fix(html.xpath(selector))
            # acc_phone = nil_fix(html.at_css('.value'))
            #
            # # ACCOUNT ADDRESS:
            # street = nil_fix(html.at_css('.adr .street-address'))
            # city = nil_fix(html.at_css('.adr .locality'))
            # state = nil_fix(html.at_css('.adr .region'))
            # zip = nil_fix(html.at_css('.adr .postal-code'))

        #     #==CONTACT FIELDS==ARRAYS
        #     full_names = empty_arr_fix(html.css('#staffList .vcard .fn'))
        #     jobs = empty_arr_fix(html.css('#staffList .vcard .title'))
        #     emails = empty_arr_fix(html.css('#staffList .vcard .email'))
        #
        #     size = full_names.length
        #     if jobs.length != size
        #         n = size - jobs.length
        #         n.times {jobs << "N/A"} if n >= 0
        #     elsif emails.length != size
        #         n = size - emails.length
        #         n.times {emails << "N/A"} if n >= 0
        #     end
        #
        #     fnames = []
        #     lnames = []
        #     full_names.each do |name|
        #         words = name.split(' ')
        #         fnames << words[0]
        #         lnames << words[-1]
        #     end
        #
        #     for i in 0...size
        #         add_indexer_row_with("Web Contacts", "Dealer.com", org, street, city, state, zip, acc_phone, jobs[i], fnames[i], lnames[i], full_names[i], emails[i], "Web Contacts", "Dealer Site", "")
        #     end
        # rescue
        #     error_indicator(url, "Dearler.com")
        #     puts "\n\n===== Dealer.com Error | Msg: #{$!.message} =====\n\n"
        # end
    # end # End of Main Method: "def ddc_scraper"


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
            # #==ACCOUNT FIELDS==ARRAYS
            # org = html.at_css('.dealerName').text
            # acc_phones = html.css('.callNowClass').collect {|phone| phone.text}
            # acc_phones_str = acc_phones.join(', ')
            #
            # # ACCOUNT FULL ADDRESS: #=NEED TO SPLIT!!!!!!!
            # addy = html.at_css('.adr').text

            #==CONTACT FIELDS==ARRAYS
            # full_names = html.css('.staff-title').map {|name| name.text.strip}
            # jobs = html.css('.staff-desc').map {|job| job.text.strip}
            # phones = html.css('.phone1').map {|phone| phone.text.strip}
            # emails = html.css('.email').map {|email| email.text.strip}

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
            # #==ACCOUNT FIELDS==ARRAYS
            # org_sel = "//img[@class='cblt-lazy']/@alt"
            # org = html.xpath(org_sel)
            # if org.empty?
            #     org = "Not Found"
            # end
            # acc_phone = html.css('.CONTACTUsInfo').text
            #
            # # ACCOUNT FULL ADDRESS: # ONE SINGLE ADDRESS STRING
            # selector = "//a[@href='HoursAndDirections']"
            # street = html.xpath(selector).text
            # city = ''
            # state = ''
            # zip = ''

            #==CONTACT FIELDS==ARRAYS
            # full_names = html.css('.contact-name').map {|name| name.text.strip}
            # jobs = html.css('.contact-title').map {|job| job.text.strip}
            # emails = html.css('.contact-email').map {|email| email.text.strip}

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
            # #==ACCOUNT FIELDS==ARRAYS
            # org = html.at_css('.foot-thanks h1').text
            # acc_phones = html.css('#salesphone').collect {|phone| phone.text}
            # acc_phones_str = acc_phones.join(', ')
            #
            # # ACCOUNT FULL ADDRESS:
            # addy = html.at_css('.hide-address').text.split(' ')
            # street = addy[0..-4].join(' ')
            # city = drop_comma(addy[-3])
            # state = drop_comma(addy[-2])
            # zip = addy[-1]

            #==CONTACT FIELDS==ARRAYS
            # full_names = html.css('.fn').map {|name| name.text.strip}
            # jobs = html.css('.position').map {|job| job.text.strip}
            # phones = html.css('.tel').map {|phone| phone.text.strip}
            # selector = "//meta[@itemprop='email']/@content"
            # nodes = html.xpath(selector)
            # emails = nodes.map {|n| n}

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
            # #==ACCOUNT FIELDS==ARRAYS
            # org = html.at_css('.organization-name').text
            # acc_phones = html.css('.tel').collect {|phone| phone.text}
            # acc_phones_str = acc_phones.join(', ')
            #
            # # ACCOUNT ADDRESS:
            # street = html.at_css('.street-address').text
            # city = html.at_css('.locality').text
            # state = html.at_css('.region').text
            # zip = html.at_css('.postal-code').text

            # #==CONTACT FIELDS==ARRAYS
            # full_names = []  # BEGIN NAMES ARRAY
            # html.css('.staff-item h3').map {|name|
            #     unless full_names.include?(name.text.strip)
            #         full_names.push(name.text.strip)
            #     end
            # } # END NAMES
            #
            # jobs = []  # BEGIN JOBS ARRAY
            # html.css('.staff-item h4').map {|job|
            #     unless jobs.include?(job.text.strip)
            #         jobs.push(job.text.strip)
            #     end
            # }  # END JOBS ARRAY
            #
            # phones = html.css('.staffphone').map {|phone| phone.text.strip}
            #
            # # EMAILS BELOW
            # selector = "//a[starts-with(@href, 'mailto:')]/@href"
            # nodes = html.xpath(selector)
            # emails =  nodes.collect {|n| n.value[7..-1]}
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
