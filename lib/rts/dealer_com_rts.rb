class DealerComRts
    def rooftop_scraper(html)
        selector = "//meta[@name='author']/@content"
        org = html.xpath(selector).text if html.xpath(selector)
        street = html.at_css('.adr .street-address').text if html.at_css('.adr .street-address')
        city = html.at_css('.adr .locality').text if html.at_css('.adr .locality')
        state = html.at_css('.adr .region').text if html.at_css('.adr .region')
        zip = html.at_css('.adr .postal-code').text if html.at_css('.adr .postal-code')
        phone = html.at_css('.value').text if html.at_css('.value')

        {org: org, street: street, city: city, state: state, zip: zip, phone: phone}
    end
end