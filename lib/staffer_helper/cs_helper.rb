class CsHelper # Contact Scraper Helper Method
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
            # Clean & Divide full name
            if staff_hash[:full_name]
                name_parts = staff_hash[:full_name].split(" ")
                staff_hash[:fname] = name_parts[0].strip
                staff_hash[:lname] = name_parts[1].strip
                staff_hash[:full_name] = staff_hash[:full_name].strip
            else
                staff_hash[:fname] = staff_hash[:fname].strip if staff_hash[:fname]
                staff_hash[:lname] = staff_hash[:lname].strip if staff_hash[:lname]
            end

            # Clean email address
            if email = staff_hash[:email]
                email.gsub!(/mailto:/, '') if email.include?("mailto:")
                staff_hash[:email] = email.strip
            end

            # Clean rest
            staff_hash[:job] = staff_hash[:job].strip if staff_hash[:job]
            staff_hash[:phone] = staff_hash[:phone].strip if staff_hash[:phone]
        end
        create_staffer(staff_hash_array)
    end

    def create_staffer(staff_hash_array)
        puts ">>> #{staff_hash_array.count} staffs will be saved to Staffer table."
        staff_hash_array.each do |staff_hash|
            full_name = staff_hash[:full_name] ? staff_hash[:full_name] : staff_hash[:fname] + " " + staff_hash[:lname]

            p staff_hash

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
end