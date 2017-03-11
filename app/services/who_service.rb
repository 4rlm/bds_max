class WhoService
    require 'rubygems'
    require 'whois'
    require 'csv'
    require 'mechanize'
    require 'open-uri'
    require 'nokogiri'
    require 'uri'
    require 'socket'


    def who_starter
        a=0
        z=2
        indexers = Indexer.where.not(clean_url: nil).where(who_status: nil).where.not(staff_url: nil)[a..z]

        # indexers = Indexer.where(clean_url: "http://www.kendallfordanchorage.com")

        counter=0
        indexers.each do |indexer|
            counter+=1
            puts "\n#{'='*30}\n[#{a}...#{z}]  (#{counter}/#{range})"

            url = indexer.clean_url

            uri = URI(url)
            scheme = uri.scheme
            host = uri.host

            if host.include?("www.")
                host.gsub!("www.", "")
            end
            host_www = "www.#{host}"

            #======= Start Whois Section ===========|X|
            r = Whois.whois(host)
            if r.available?
                url_validation = "Invalid URL"
                add_csv_whois([url, scheme, host, url_validation])
            else
                url_validation = "Valid URL"
                p = r.parser

                #----------------- Registrant Contact Variables ----------------------
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
                    registrant_country = r.registrant_contacts[0].country
                    registrant_country_code = r.registrant_contacts[0].country_code
                    registrant_phone = r.registrant_contacts[0].phone
                    registrant_fax = r.registrant_contacts[0].fax
                    registrant_email = r.registrant_contacts[0].email
                    registrant_url = r.registrant_contacts[0].url
                    registrant_created_on = r.registrant_contacts[0].created_on
                    registrant_updated_on = r.registrant_contacts[0].updated_on

                    puts "------------- #{registrant_contact_info} -------------"
                    puts "ID: #{registrant_id}"
                    puts "Type: #{registrant_type}"
                    puts "Name: #{registrant_name}"
                    puts "Organization: #{registrant_organization}"
                    puts "Address: #{registrant_address}"
                    puts "City: #{registrant_city}"
                    puts "Zip: #{registrant_zip}"
                    puts "State: #{registrant_state}"
                    puts "Country: #{registrant_country}"
                    puts "Country Code: #{registrant_country_code}"
                    puts "Phone: #{registrant_phone}"
                    puts "Fax: #{registrant_fax}"
                    puts "Email: #{registrant_email}"
                    puts "URL: #{registrant_url}"
                    puts "Created: #{registrant_created_on}"
                    puts "Updated: #{registrant_updated_on}"
                    puts ""
                end # Ends Registrant Contacts


                # ----------------- Admin Contact Variables --------------------------
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
                    admin_country = r.admin_contacts[0].country
                    admin_country_code = r.admin_contacts[0].country_code
                    admin_phone = r.admin_contacts[0].phone
                    admin_fax = r.admin_contacts[0].fax
                    admin_email = r.admin_contacts[0].email
                    admin_url = r.admin_contacts[0].url
                    admin_created_on = r.admin_contacts[0].created_on
                    admin_updated_on = r.admin_contacts[0].updated_on

                    puts "------------- #{admin_contact_info} -------------"
                    puts "ID: #{admin_id}"
                    puts "Type: #{admin_type}"
                    puts "Name: #{admin_name}"
                    puts "Organization: #{admin_organization}"
                    puts "Address: #{admin_address}"
                    puts "City: #{admin_city}"
                    puts "Zip: #{admin_zip}"
                    puts "State: #{admin_state}"
                    puts "Country: #{admin_country}"
                    puts "Country Code: #{admin_country_code}"
                    puts "Phone: #{admin_phone}"
                    puts "Fax: #{admin_fax}"
                    puts "Email: #{admin_email}"
                    puts "URL: #{admin_url}"
                    puts "Created: #{admin_created_on}"
                    puts "Updated: #{admin_updated_on}"
                    puts ""
                end # Ends Admin Contacts


                # ----------------- Tech Contact Variables --------------------------
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
                    tech_country = r.technical_contacts[0].country
                    tech_country_code = r.technical_contacts[0].country_code
                    tech_phone = r.technical_contacts[0].phone
                    tech_fax = r.technical_contacts[0].fax
                    tech_email = r.technical_contacts[0].email
                    tech_url = r.technical_contacts[0].url
                    tech_created_on = r.technical_contacts[0].created_on
                    tech_updated_on = r.technical_contacts[0].updated_on

                    puts "------------- #{tech_contact_info} -------------"
                    puts "ID: #{tech_id}"
                    puts "Type: #{tech_type}"
                    puts "Name: #{tech_name}"
                    puts "Organization: #{tech_organization}"
                    puts "Address: #{tech_address}"
                    puts "City: #{tech_city}"
                    puts "Zip: #{tech_zip}"
                    puts "State: #{tech_state}"
                    puts "Country: #{tech_country}"
                    puts "Country Code: #{tech_country_code}"
                    puts "Phone: #{tech_phone}"
                    puts "Fax: #{tech_fax}"
                    puts "Email: #{tech_email}"
                    puts "URL: #{tech_url}"
                    puts "Created: #{tech_created_on}"
                    puts "Updated: #{tech_updated_on}"
                    puts ""
                end # Ends Technical Contacts


                # ----------------- Tech Data Variables --------------------------
                tech_data_info = "Tech Data Info:>"
                domain = p.domain
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

                indexers = Indexer.where.not(clean_url: nil).where(who_status: nil).where.not(staff_url: nil)[a..z]

                indexer.update_attributes(indexer_status: who_status, who_status: who_status)
                


                indexer.update_attributes(who_status: who_status, url_status: url_status, domain_id: domain_id, ip: ip, server1: server1, server2: server2, registrar_url: registrar_url, registrar_id: registrar_id, registrant_id: registrant_id, registrant_type: registrant_type, registrant_name: registrant_name, registrant_organization: registrant_organization, registrant_address: registrant_address, registrant_city: registrant_city, registrant_zip: registrant_zip, registrant_state: registrant_state, registrant_country: registrant_country, registrant_country_code: registrant_country_code, registrant_phone: registrant_phone, registrant_fax: registrant_fax, registrant_email: registrant_email, registrant_url: registrant_url, registrant_created_on: registrant_created_on, registrant_updated_on: registrant_updated_on, admin_id: admin_id, admin_type: admin_type, admin_name: admin_name, admin_organization: admin_organization, admin_address: admin_address, admin_city: admin_city, admin_zip: admin_zip, admin_state: admin_state, admin_country: admin_country, admin_country_code: admin_country_code, admin_phone: admin_phone, admin_fax: admin_fax, admin_email: admin_email, admin_url: admin_url, admin_created_on: admin_created_on, admin_updated_on: admin_updated_on, tech_id: tech_id, tech_type: tech_type, tech_name: tech_name, tech_organization: tech_organization, tech_address: tech_address, tech_city: tech_city, tech_zip: tech_zip, tech_state: tech_state, tech_country: tech_country, tech_country_code: tech_country_code, tech_phone: tech_phone, tech_fax: tech_fax, tech_email: tech_email, tech_url: tech_url, tech_created_on: tech_created_on, tech_updated_on: tech_updated_on)





                # puts "---------- (G) Timeout Extender --------------------------"
                # w = Whois::Client.new(:timeout => 10)
                # w.timeout # => 10
                # w.timeout = 5
                # w.timeout # => 5
                # w.lookup(url)
                # end
                # puts "----------------------------------------------------------------------"

            end # End of if r.available?

            # ------ Final Results Summary for both Valid & Invalid URLs -------
            puts "URL: #{url}"
            puts "Status: #{url_validation}"
            puts "Scheme: #{scheme} & Host: #{host}"
            puts "====== Completed Whois Search ======"
            puts ""

            # delay_time = rand(39)
            # sleep(delay_time)


        end

    end


end # WhoService class Ends ---
