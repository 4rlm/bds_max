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
            name_parts = staff_hash[:full_name].split(" ")
            staff_hash[:fname] = name_parts[0].strip
            staff_hash[:lname] = name_parts[1].strip
            staff_hash[:full_name] = staff_hash[:full_name].strip

            # Clean email address
            email = staff_hash[:email]
            email.gsub!(/mailto:/, '') if email.include?("mailto:")
            staff_hash[:email] = email.strip

            # Clean rest
            staff_hash[:job] = staff_hash[:job].strip
            staff_hash[:phone] = staff_hash[:phone].strip
        end
        create_staffer(staff_hash_array)
    end

    def create_staffer(staff_hash_array)
        puts ">>> #{staff_hash_array.count} staffs will be saved to Staffer table."
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
end