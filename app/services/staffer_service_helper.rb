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
                add_indexer_row_with("Scraped", "Dealer.com", org, street, city, state, zip, acc_phone, jobs[i], fnames[i], lnames[i], full_names[i], emails[i], "Scraped", "Dealer Site", "site_cont_influence_ex")
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

    def add_indexer_row_with(staffer_status, temp, org, street, city, state, zip, acc_phone, jobs, fnames, lnames, full_names, emails, cont_status, cont_source, site_cont_influence)
        @cols_hash[:staffer_status] = staffer_status
        @cols_hash[:template] = temp
        @cols_hash[:site_acct] = org
        @cols_hash[:site_street] = street
        @cols_hash[:site_city] = city
        @cols_hash[:site_state] = state
        @cols_hash[:site_zip] = zip
        @cols_hash[:site_ph] = acc_phone
        @cols_hash[:site_cont_job_raw] = jobs
        @cols_hash[:site_cont_fname] = fnames
        @cols_hash[:site_cont_lname] = lnames
        @cols_hash[:site_cont_fullname] = full_names
        @cols_hash[:site_cont_email] = emails
        @cols_hash[:cont_status] = cont_status
        @cols_hash[:cont_source] = cont_source
        @cols_hash[:site_cont_influence] = site_cont_influence

        core = Core.find_by(sfdc_id: @cols_hash[:sfdc_id])

        Staffer.create(@cols_hash)
        core.update_attributes(staffer_status: staffer_status, template: temp, site_acct: org, site_street: street, site_city: city, site_state: state, site_zip: zip, site_ph: acc_phone)
    end

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
                    add_indexer_row_with(["Scraped", "DealerOn", org, street, city, state, zip, acc_phone, jobs[i], fnames[i], lnames[i], full_names[i], emails[i], "Scraped", "Dealer Site", "site_cont_influence_ex"])
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
                    add_indexer_row_with(["Scraped", "Cobalt", org, street, city, state, zip, acc_phone, jobs[i], fnames[i], lnames[i], full_names[i], emails[i], "Scraped", "Dealer Site", "site_cont_influence_ex"])
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
                    add_indexer_row_with(["Scraped", "DealerFire", org, street, city, state, zip, acc_phone, jobs[i], fnames[i], lnames[i], full_names[i], emails[i], "Scraped", "Dealer Site", "site_cont_influence_ex"])
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
                    add_indexer_row_with(["Scraped", "DealerInspire", org, street, city, state, zip, acc_phone, jobs[i], fnames[i], lnames[i], full_names[i], emails[i], "Scraped", "Dealer Site", "site_cont_influence_ex"])
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
end
