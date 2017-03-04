class DealeronRts
    def rooftop_scraper(html)
        acc_phones = html.css('.callNowClass').collect {|phone| phone.text if phone}
        raw_full_addr = html.at_css('.adr').text if html.at_css('.adr')
        full_addr_arr = raw_full_addr.split(",") if raw_full_addr
        zip_state_arr = full_addr_arr[-1].split(" ")

        org = html.at_css('.dealerName').text if html.at_css('.dealerName')
        street = full_addr_arr[-3] if full_addr_arr
        city = full_addr_arr[-2] if full_addr_arr
        state = zip_state_arr[-2] if zip_state_arr
        zip = zip_state_arr[-1] if zip_state_arr
        phone = acc_phones[0]
        ### MOVED FROM rt_address_formatter B/C DESIGNED ONLY FOR DO TEMP.
        if (city && street == nil) && city.include?("\r")
            street_city_arr = city.split("\r")
            street = street_city_arr[0] unless street_city_arr[0] == nil
            city = street_city_arr[-1] unless street_city_arr[-1] == nil
        end
        
        {org: org, street: street, city: city, state: state, zip: zip, phone: phone}
    end
end