module StaffersHelper
    def staffer_status_list
        ["Ready", "Search Error", "Temp Error", "Queued", "No Matches", 'Try Again', "Scraped", 'Verified', 'Destroy', "Matched"]
    end

    def franchise_list
        ['Acura', 'Alfa', 'Aston', 'Audi', 'Auto', 'Autogroup', 'Automall', 'Automotive', 'Autoplex', 'Autos', 'Autosales', 'Bentley', 'Benz', 'Bmw', 'Bugatti', 'Buick', 'Cadillac', 'Cars', 'Cdjr', 'Chev', 'Chevrolet', 'Chevy', 'Chrysler', 'Cjd', 'Corvette', 'Daewoo', 'Dealer', 'Dodge', 'Ferrari', 'Fiat', 'Ford', 'Gm', 'Gmc', 'Group', 'Highline', 'Honda', 'Hummer', 'Hyundai', 'Imports', 'Infiniti', 'Isuzu', 'Jaguar', 'Jeep', 'Kia', 'Lamborghini', 'Lexus', 'Lincoln', 'Lotus', 'Maserati', 'Mazda', 'Mb', 'Mclaren', 'Mercedes', 'Mercury', 'Mini', 'Mitsubishi', 'Motor', 'Motors', 'Nissan', 'Oldsmobile', 'Plymouth', 'Pontiac', 'Porsche', 'Ram', 'Range', 'Rolls', 'Rover', 'Royce', 'Saab', 'Saturn', 'Scion', 'Smart', 'Subaru', 'Superstore', 'Suzuki', 'Toyota', 'Trucks', 'Usedcars', 'Volkswagen', 'Volvo', 'Vw']
    end

    def template_list
        ['Dealer.com', 'DealerOn', 'Cobalt', 'DealerFire', 'DealerInspire', ["None", nil]]
    end

    def job_title_list
        ["CEO", "Dealer Principal", "Director", "Fixed Operations Manager", "Ecommerce Director", "General Manager", "General Sales Manager", "Internet Manager", "Internet Director", "Marketing Manager", "Marketing Director", "President", "Sales Manager", "Salesperson", "Used Car Manager", "Used Car Director", "Variable Operations Director", "Vice President" ]
    end

    def influence_list
        ["Decision Influencer", "Decision Maker", "Other", "N/A", ["None", nil]]
    end

    def inactive_list
        [["Active", "0"], ["Inactive", "1"]]
    end

    def contact_status_list
        ["Scraped", "SFDC", "Merged", "Merge-Request", "Hide", "Destroy"]
    end

    def contact_source_list
        ["Dealer Site", "SFDC", "Other"]
    end

end
