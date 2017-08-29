class RtsManager # Update database with the result of RoofTop Scraper
  include PhoneFormatter

  # STRIPS AND FORMATS DATA BEFORE SAVING TO DB
  def address_formatter(org, street, city, state, zip, phone, rts_phones, url, indexer)
    org = nil if org.blank?
    street = nil if street.blank?
    city = nil if city.blank?
    state = nil if state.blank?
    zip = nil if zip.blank?
    phone = nil if phone.blank?

    org.strip! if org
    street.strip! if street
    city.strip! if city
    state.strip! if state
    zip.strip! if zip

    if zip && state && zip.length < 5 && state > 2
      temp_zip = state
      temp_state = zip
      zip = temp_zip
      state = temp_state
    end

    full_addr_street = "#{street}, " if street
    full_addr_city = "#{city}, " if city
    full_addr_state = "#{state}, " if state
    full_addr_zip = "#{zip}" if zip
    full_addr = "#{full_addr_street}#{full_addr_city}#{full_addr_state}#{full_addr_zip}"
    full_addr.strip!

    if full_addr && full_addr[-1] == ","
      full_addr = full_addr[0...-1]
      full_addr.strip!
    end

    if full_addr && full_addr[0] == ","
      full_addr = full_addr[1..-1]
      full_addr.strip!
    end

    full_addr = nil if full_addr.blank?  || full_addr == ","

    results_processor(org, street, city, state, zip, phone, rts_phones, full_addr, url, indexer)
  end

  def results_processor(org, street, city, state, zip, phone, rts_phones, full_addr, url, indexer)
    phone = phone_formatter(phone) if phone
    phones = clean_phones_arr(rts_phones)

    if org || street || city || state || zip || phone || full_addr

      printer(org, street, city, state, zip, phone, phones, full_addr, url, indexer)

      indexer.update_attributes(indexer_status: "AccountScraper", acct_name: org, rt_sts: "AS Result", full_addr: full_addr, street: street, city: city, state: state, zip: zip, phone: phone, phones: phones, account_scrape_date: DateTime.now)
    else
      puts "url: #{url} \n\nAccountScraper No-Result - Check Template Version!\n\n#{'='*30}\n\n"
      indexer.update_attributes(indexer_status: "AccountScraper", acct_name: org, rt_sts: "AS No-Result", account_scrape_date: DateTime.now)
    end
  end

  # ================== Helper ==================

  def printer(org, street, city, state, zip, phone, rts_phones, full_addr, url, indexer)
    puts "template: #{indexer.template}\nurl: #{url} \n\nRT Result - Success!\n\n"

    puts "org: #{org.nil? ? "nil" : org.inspect}"
    puts "street: #{street.nil? ? "nil" : street.inspect}"
    puts "city: #{city.nil? ? "nil" : city.inspect}"
    puts "state: #{state.nil? ? "nil" : state.inspect}"
    puts "zip: #{zip.nil? ? "nil" : zip.inspect}"
    puts "phone: #{phone.nil? ? "nil" : phone.inspect}"
    puts "rts_phones: #{rts_phones.empty? ? [] : rts_phones.inspect}"
    puts "full_addr: #{full_addr.nil? ? "nil" : full_addr.inspect}"

    puts "\n#{'='*30}\n\n"
  end

  def rts_phones_finder(html)
    raw_data_1 = html.at_css('body').inner_html
    raw_data_2 = html.at_css('body').text

    reg = Regexp.new("[(]?[0-9]{3}[ ]?[)-.]?[ ]?[0-9]{3}[ ]?[-. ][ ]?[0-9]{4}")
    invalid = Regexp.new("[0-9]{5,}")

    data_1 = raw_data_1.scan(reg)
    data_2 = raw_data_2.scan(reg)

    sub_phones = data_1.uniq + data_2.uniq
    phones = sub_phones.uniq.sort
    result = phones.reject { |x| invalid.match(x) }
    return result
  end

end
