class SolitaryService
    # This cleans the existing Solitary table.
    def solitary_cleaner_btn
        matched_urls = Core.all.map(&:matched_url)
        solitaries = Solitary.all

        solitaries.each do |solitary|
            if matched_urls.include?(solitary.solitary_url)
                puts ">>>>> solitary_cleaner_btn | DELETE solitary url: #{solitary.solitary_url}"
                solitary.destroy
            end
        end
    end

    # When a row in Core is updated to "Matched", check if its url exists in Solitary.
    # If so, delete the matched url in Solitary.
    def check_solitary_for_matched(matched_url)
        solitary = Solitary.find_by(solitary_url: matched_url)
        if solitary
            puts ">>>>> check_solitary_for_matched | DELETE solitary url: #{solitary.solitary_url}"
            solitary.destroy
        end
    end
end
