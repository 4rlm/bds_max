class CsHelper # Contact Scraper Helper Method
    def initialize
        @rts_manager = RtsManager.new
    end

    def print_result(indexer, url, hash_array)
        puts "\ndomain: #{indexer.clean_url.inspect}\ntemplate: #{indexer.template.inspect}\nurl: #{url.inspect}\n\n"
        # hash_array.each do |hash|
        #     hash.each do |key, value|
        #         puts "#{key}: #{value.inspect}"
        #     end
        #     puts "-------------------------------"
        # end
    end

    def prep_create_staffer(indexer, staff_hash_array)
        staff_hash_array.each do |staff_hash|
            # Clean & Divide full name
            if staff_hash[:full_name]
                name_parts = staff_hash[:full_name].split(" ")
                staff_hash[:fname] = name_parts[0].strip
                staff_hash[:lname] = name_parts[-1].strip
                staff_hash[:full_name] = staff_hash[:full_name].strip
            else
                staff_hash[:fname] = staff_hash[:fname].strip if staff_hash[:fname]
                staff_hash[:lname] = staff_hash[:lname].strip if staff_hash[:lname]
                staff_hash[:full_name] = staff_hash[:fname] + " " + staff_hash[:lname] if staff_hash[:fname] && staff_hash[:lname]
            end

            # Clean email address
            if email = staff_hash[:email]
                email.gsub!(/mailto:/, '') if email.include?("mailto:")
                staff_hash[:email] = email.strip
            end

            # Clean rest
            staff_hash[:job] = staff_hash[:job].strip if staff_hash[:job]
            staff_hash[:phone] = staff_hash[:phone].strip if staff_hash[:phone]

            # Cleaning code goes here.
            ## 1) phone number has "EXT" kind of string.
            ## 2) job has \t and \n.
        end
        create_staffer(indexer, staff_hash_array)
    end

    def create_staffer(indexer, staff_hash_array)
        puts "\n\n#{"="*15} CLEAN DATA #{"="*15}\n#{staff_hash_array.count} staffs will be saved to Staffer table.\n\n"
        phones = []
        staff_hash_array.each do |staff_hash|
            printer(staff_hash)

            Staffer.find_or_create_by(
                fullname:       staff_hash[:full_name],
                domain:         indexer.clean_url
            ) do |staffer|
                staffer.fname          = staff_hash[:fname],
                staffer.lname          = staff_hash[:lname],
                staffer.job_raw        = staff_hash[:job],
                staffer.email          = staff_hash[:email],
                staffer.phone          = staff_hash[:phone],
                staffer.cont_source    = "Web",
                staffer.cont_status    = "Scraped",
                staffer.staffer_status = "Scraped",
                staffer.template       = indexer.template
            end

            ph = staff_hash[:phone]
            phones << ph if ph && !ph.blank? && !phones.include?(ph)
        end
        update_indexer_attrs(indexer, phones, staff_hash_array.count)
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

    def printer(staff_hash)
        staff_hash.each do |key, val|
            puts "#{key}: #{val.nil? ? "nil" : val.inspect}"
        end
        puts '-'*30
    end

    def update_indexer_attrs(indexer, phones, count)
        indexer_phones = indexer.phones
        puts "\nOLD phones: #{indexer_phones}"
        indexer_phones.concat(phones)
        puts "\nNEW phones: #{indexer_phones} \n indexer status will be updated.\n#{'='*30}\n\n"

        if count > 0
            indexer.update_attributes(phones: phones, contact_status: "Staffer Result", indexer_status: "Staffer Result")
        else
            indexer.update_attributes(phones: phones, contact_status: "Staffer Result", indexer_status: "No Contacts")
        end
    end

    def job_detector(str)
        return false if str.length > 48 || include_neg(str)

        jobs = ["director", "sales", "advisor", "manager", "agent", "president", "accountant", "accounting", "coordinator", "engineer", "officer", "marketing", "specialist", "assistant", "professional", "owner", "owned", "receptionist", "consultant", "admin", "parts", "tech", "shop", "estimator", "cashier", "shipping", "receiving", "warranty", "executive", "recruiter", "trainer", "inventory", "certified", "maintenance", "license", "clerk", "leasing", "support", "customer", "online", "transmission", "dealer", "principal", "shuttle", "driver", "writer", "scheduler", "business", "develop", "representative", "fleet", "associate", "service", "transportation", "attendant"]

        str = str.downcase
        jobs.each do |job|
            return true if str.include?(job)
        end

        return false
    end

    def name_detector(str)
        return false if str.length > 48 || include_neg(str)

        parts = str.split(" ")
        name_reg = Regexp.new("[@./0-9]")
        !str.scan(name_reg).any? && (parts.length < 5 && parts.length > 1)
    end

    def phone_detector(str)
        return false if str.length > 48 || include_neg(str)

        num_reg = Regexp.new("[0-9]{3}")
        num_reg.match(str) && str.length < 17
    end

    def email_cleaner(str)
        str ? str.gsub(/^mailto:/, '') : str
    end

    def include_neg(str)
        negs = ["today", "great", "call", "give", "contact", "saving", "@", "!", "?"]
        negs.each do |neg|
            return true if str.include?(neg)
        end
        return false
    end

    # In case, template scraper wants to use this way.
    # Just add this line: `staff_hash_array = @helper.standard_scraper(staffs)`
    def standard_scraper(staffs)
        staff_hash_array = []

        if staffs.any?
            staffs.each do |staff|
                staff_hash = {}
                # Get name, job, phone
                info_ori = staff.text.split("\n").map do |el|
                    el = el.delete("\t")
                    el = el.delete(",")
                    el = el.delete("\r")
                    el = el.strip
                end
                infos = info_ori.delete_if {|el| el.blank?}
                infos = infos.uniq

                infos.each do |info|
                    name_bool = name_detector(info)
                    job_bool = job_detector(info)
                    phone_bool = phone_detector(info)

                    if job_bool
                        staff_hash[:job] = info
                    elsif name_bool && !job_bool && !phone_bool
                        staff_hash[:full_name] = info
                    elsif phone_bool
                        staff_hash[:phone] = @rts_manager.phone_formatter(info)
                    end
                end

                # Get email
                data = staff.inner_html
                regex = Regexp.new("[a-z]+[@][a-z]+[.][a-z]+")
                email_reg = regex.match(data)
                staff_hash[:email] = email_reg.to_s if email_reg

                staff_hash_array << staff_hash
            end
        end
        staff_hash_array
    end
end
