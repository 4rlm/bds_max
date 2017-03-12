class WhoService
    require 'rubygems'
    require 'whois'
    require 'csv'
    require 'mechanize'
    require 'open-uri'
    require 'nokogiri'
    require 'uri'
    require 'socket'
    require 'indexer_helper/rts/rts_manager'


    def who_starter
        a=0
        z=-1
        range = z-a

        indexers = Indexer.where.not(clean_url: nil).where(who_status: nil).where.not(staff_url: nil)[a..z]

        counter=0
        indexers.each do |indexer|
            counter+=1
            puts "\n#{'='*30}\n[#{a}...#{z}]  (#{counter}/#{range})"

            url = indexer.clean_url
            begin
                uri = URI(url)
                scheme = uri.scheme
                host = uri.host

                if host.include?("www.")
                    host.gsub!("www.", "")
                end
                host_www = "www.#{host}"

                #Start Whois Section
                r = Whois.whois(host)
                if r.available?
                    url_validation = "Invalid URL"
                else
                    url_validation = "Valid URL"
                    p = r.parser
                    # rts_manager = RtsManager.new

                    ## Registrant Contact Variables
                    if r.registrant_contacts.present?
                        registrant_contact_info = "Registrant Contact Info:>"
                        registrant_id = r.registrant_contacts[0].id
                        registrant_type =r.registrant_contacts[0].type
                        registrant_name = r.registrant_contacts[0].name
                        registrant_organization = r.registrant_contacts[0].organization
                        registrant_address = r.registrant_contacts[0].address
                        registrant_city = r.registrant_contacts[0].city
                        registrant_zip = r.registrant_contacts[0].zip
                        registrant_state = r.registrant_contacts[0].state

                        registrant_phone1 = r.registrant_contacts[0].phone
                        puts registrant_phone1
                        registrant_phone = phone_formatter(registrant_phone1)
                        registrant_fax1 = r.registrant_contacts[0].fax
                        puts registrant_fax1
                        registrant_fax = phone_formatter(registrant_fax1)

                        registrant_email = r.registrant_contacts[0].email
                        registrant_url = r.registrant_contacts[0].url

                        puts "------------- #{registrant_contact_info} -------------"
                        puts "ID: #{registrant_id}"
                        puts "Type: #{registrant_type}"
                        puts "Name: #{registrant_name}"
                        puts "Organization: #{registrant_organization}"
                        puts "Address: #{registrant_address}"
                        puts "City: #{registrant_city}"
                        puts "Zip: #{registrant_zip}"
                        puts "State: #{registrant_state}"
                        puts "Phone: #{registrant_phone}"
                        puts "Fax: #{registrant_fax}"
                        puts "Email: #{registrant_email}"
                        puts "URL: #{registrant_url}"
                        puts ""
                    end # Ends Registrant Contacts


                    ## Admin Contact Variables
                    if r.admin_contacts.present?
                        admin_contact_info = "Admin Contact Info:>"
                        admin_id = r.admin_contacts[0].id
                        admin_type =r.admin_contacts[0].type
                        admin_name = r.admin_contacts[0].name
                        admin_organization = r.admin_contacts[0].organization
                        admin_address = r.admin_contacts[0].address
                        admin_city = r.admin_contacts[0].city
                        admin_zip = r.admin_contacts[0].zip
                        admin_state = r.admin_contacts[0].state

                        admin_phone1 = r.admin_contacts[0].phone
                        puts admin_phone1
                        admin_phone = phone_formatter(admin_phone1)
                        admin_fax2 = r.admin_contacts[0].fax
                        admin_fax2
                        admin_fax = phone_formatter(admin_fax2)

                        admin_email = r.admin_contacts[0].email
                        admin_url = r.admin_contacts[0].url
                        admin_created_on = r.admin_contacts[0].created_on

                        puts "------------- #{admin_contact_info} -------------"
                        puts "ID: #{admin_id}"
                        puts "Type: #{admin_type}"
                        puts "Name: #{admin_name}"
                        puts "Organization: #{admin_organization}"
                        puts "Address: #{admin_address}"
                        puts "City: #{admin_city}"
                        puts "Zip: #{admin_zip}"
                        puts "State: #{admin_state}"
                        puts "Phone: #{admin_phone}"
                        puts "Fax: #{admin_fax}"
                        puts "Email: #{admin_email}"
                        puts "URL: #{admin_url}"
                        puts "Created: #{admin_created_on}"
                        puts ""
                    end # Ends Admin Contacts


                    ## Tech Contact Variables
                    if r.technical_contacts.present?
                        tech_contact_info = "Tech Contact Info:>"
                        tech_id = r.technical_contacts[0].id
                        tech_type =r.technical_contacts[0].type
                        tech_name = r.technical_contacts[0].name
                        tech_organization = r.technical_contacts[0].organization
                        tech_address = r.technical_contacts[0].address
                        tech_city = r.technical_contacts[0].city
                        tech_zip = r.technical_contacts[0].zip
                        tech_state = r.technical_contacts[0].state

                        tech_phone1 = r.technical_contacts[0].phone
                        puts tech_phone1
                        tech_phone = phone_formatter(tech_phone1)
                        tech_fax1 = r.technical_contacts[0].fax
                        puts tech_fax1
                        tech_fax = phone_formatter(tech_fax1)

                        tech_email = r.technical_contacts[0].email
                        tech_url = r.technical_contacts[0].url

                        puts "------------- #{tech_contact_info} -------------"
                        puts "ID: #{tech_id}"
                        puts "Type: #{tech_type}"
                        puts "Name: #{tech_name}"
                        puts "Organization: #{tech_organization}"
                        puts "Address: #{tech_address}"
                        puts "City: #{tech_city}"
                        puts "Zip: #{tech_zip}"
                        puts "State: #{tech_state}"
                        puts "Phone: #{tech_phone}"
                        puts "Fax: #{tech_fax}"
                        puts "Email: #{tech_email}"
                        puts "URL: #{tech_url}"
                        puts ""
                    end # Ends Technical Contacts

                    ## Tech Data Variables
                    tech_data_info = "Tech Data Info:>"
                    # domain = p.domain
                    domain = url
                    domain_id = r.domain_id
                    ip = IPSocket::getaddress(host_www)
                    server1 = r.nameservers[0]
                    server2 = r.nameservers[1]
                    registrar_url = p.registrar.url
                    registrar_id = p.registrar.id

                    puts "------------- #{tech_data_info} -------------"
                    puts "Domain: #{domain}"
                    puts "Domain ID: #{domain_id}"
                    puts "IP: #{ip}"
                    puts "Server 1: #{server1}"
                    puts "Server 2: #{server2}"
                    puts "Registrar URL: #{registrar_url}"
                    puts "Registrar URL: #{registrar_id}"
                    puts ""

                    who_status = "WhoIs Result"
                    url_status = "WhoIs Result"

                    registrant_pin = acct_pin_gen(registrant_address, registrant_zip)
                    admin_pin = acct_pin_gen(admin_address, admin_zip)
                    tech_pin = acct_pin_gen(tech_address, tech_zip)

                    puts "\n\n\n============================="
                    puts "registrant_pin: #{registrant_pin}"
                    puts "admin_pin: #{admin_pin}"
                    puts "tech_pin: #{tech_pin}"
                    puts "\n\n\n============================="

                    Who.find_or_create_by(
                        domain: indexer.clean_url
                    ) do |who|
                        who.who_status = who_status
                        who.url_status = url_validation
                        who.domain = domain
                        who.domain_id = domain_id
                        who.ip = ip
                        who.server1 = server1
                        who.server2 = server2
                        who.registrar_url = registrar_url
                        who.registrar_id = registrar_id

                        who.registrant_id = registrant_id
                        who.registrant_type = registrant_type
                        who.registrant_name = registrant_name
                        who.registrant_organization = registrant_organization
                        who.registrant_address = registrant_address
                        who.registrant_city = registrant_city
                        who.registrant_zip = registrant_zip
                        who.registrant_state = registrant_state
                        who.registrant_phone = registrant_phone
                        who.registrant_fax = registrant_fax
                        who.registrant_email = registrant_email
                        who.registrant_url = registrant_url

                        who.admin_id = admin_id
                        who.admin_type = admin_type
                        who.admin_name = admin_name
                        who.admin_organization = admin_organization
                        who.admin_address = admin_address
                        who.admin_city = admin_city
                        who.admin_zip = admin_zip
                        who.admin_state = admin_state
                        who.admin_phone = admin_phone
                        who.admin_fax = admin_fax
                        who.admin_email = admin_email
                        who.admin_url = admin_url

                        who.tech_id = tech_id
                        who.tech_type = tech_type
                        who.tech_name = tech_name
                        who.tech_organization = tech_organization
                        who.tech_address = tech_address
                        who.tech_city = tech_city
                        who.tech_zip = tech_zip
                        who.tech_state = tech_state
                        who.tech_phone = tech_phone
                        who.tech_fax = tech_fax
                        who.tech_email = tech_email
                        who.tech_url = tech_url

                        who.registrant_pin = registrant_pin
                        who.tech_pin = tech_pin
                        who.admin_pin = admin_pin
                    end

                    indexer.update_attributes(indexer_status: who_status, who_status: url_validation)

                end # End of if r.available?

                # ------ Final Results Summary for both Valid & Invalid URLs -------
                puts "URL: #{url}"
                puts "Status: #{url_validation}"
                puts "Scheme: #{scheme} & Host: #{host}"
                puts "====== Completed Whois Search ======"
                puts ""

                delay_time = rand(30)
                sleep(delay_time)
            rescue
                indexer.update_attributes(indexer_status: "WhoIs Error", who_status: "WhoIs Error")
            end


        end

    end


    def acct_pin_gen(street, zip)
        if street && zip
            street_parts = street.split(" ")
            street_num = street_parts[0]
            street_num = street_num.tr('^0-9', '')
            new_zip = zip.strip
            new_zip = zip[0..4]
            acct_pin = "z#{new_zip}-s#{street_num}"
        end
    end


    # FORMATS PHONE AS: (000) 000-0000
    def phone_formatter(phone)
        regex = Regexp.new("[A-Z]+[a-z]+")
        if !phone.blank? && (phone != "N/A" || phone != "0") && !regex.match(phone)
            phone_stripped = phone.gsub(/[^0-9]/, "")
            (phone_stripped && phone_stripped[0] == "1") ? phone_step2 = phone_stripped[1..-1] : phone_step2 = phone_stripped

            final_phone = !(phone_step2 && phone_step2.length < 10) ? "(#{phone_step2[0..2]}) #{(phone_step2[3..5])}-#{(phone_step2[6..9])}" : phone
        else
            final_phone = nil
        end
        final_phone
    end




end # WhoService class Ends ---
