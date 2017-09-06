## Call: TableDbMigrator.new.td_starter
## Description: Read below.  Handles entire id sorting finalizer.  Replaces AcctNameIdSorter, PhoneIdSorter, AddrPinIdSorter, UrlIdSorter.

class TableDbMigrator

  def initialize
    puts "\n\n#{"="*40}\n== Starting TableDbMigrator ==\nMigrates Organization, Address, Url, Phone from Core, Indexer, Location, Who\nAll relevant data will be stored in these common db tables, rather than in the old separate system.\nTHERE SHOULD BE NO DUPLICATES ANYWHERE IN ENTIRE DB!!\n#{"="*40}\n"
  end

  def td_starter
    migrate_urls_starter #=> PERFECT!
    migrate_phones_starter #=> PERFECT!
    migrate_organizations_starter #=> PERFECT!
    migrate_addresses_starter #=> PERFECT!
  end

  ############################
  def migrate_addresses_starter
    address_attrs = [:street, :city, :state, :zip, :full_addr, :addr_pin]
    core_attrs = [:sfdc_street, :sfdc_city, :sfdc_state, :sfdc_zip, :full_address, :crm_acct_pin]
    indexer_attrs = [:street, :city, :state, :zip, :full_addr, :acct_pin]
    location_attrs = [:street, :city, :state_code, :postal_code, :geo_full_addr, :geo_acct_pin]
    who_attrs = [:registrant_address, :registrant_city, :registrant_state, :registrant_zip, :who_addr_pin]

    all_addresses = Address.select(address_attrs).all.map { |row| {street: row.street, city: row.city, state: row.state, zip: row.zip, full_addr: row.full_addr, addr_pin: row.addr_pin} }.uniq
    original_addresses = all_addresses

    all_addresses += Core.select(core_attrs).all.map { |row| {street: row.sfdc_street, city: row.sfdc_city, state: row.sfdc_state, zip: row.sfdc_zip, full_addr: row.full_address, addr_pin: row.crm_acct_pin} }.uniq

    all_addresses += Indexer.select(indexer_attrs).all.map { |row| {street: row.street, city: row.city, state: row.state, zip: row.zip, full_addr: row.full_addr, addr_pin: row.acct_pin} }.uniq

    all_addresses += Location.select(location_attrs).all.map { |row| {street: row.street, city: row.city, state: row.state_code, zip: row.postal_code, full_addr: row.geo_full_addr, addr_pin: row.geo_acct_pin} }.uniq

    all_addresses += Who.select(who_attrs).all.map { |row| {street: row.registrant_address, city: row.registrant_city, state: row.registrant_state, zip: row.registrant_zip, full_addr: nil, addr_pin: row.who_addr_pin} }.uniq

    hashes_to_save = all_addresses - original_addresses

    Address.transaction { hashes_to_save.each { |data_row_hash| Address.new(data_row_hash).save } } #=> Very fast!
  end


  ############################
  def migrate_urls_starter #=> PERFECT!
    original_urls = Url.select(:url).all.map { |row| row.url }.uniq.sort
    @urls = original_urls.compact.sort.uniq
    puts @urls.count

    url_models_hashes = []
    url_models_hashes.push({ model: 'Core', fields: [:sfdc_url, :sfdc_clean_url] })
    url_models_hashes.push({ model: 'Indexer', fields: [:raw_url, :clean_url] })
    url_models_hashes.push({ model: 'Location', fields: [:url] })
    url_models_hashes.push({ model: 'Who', fields: [:domain] })

    url_models_hashes.each do |model_hash|
      @urls += extract_values(model_hash).compact.sort.uniq
      puts @urls.count
    end

    new_urls = @urls - original_urls
    new_urls.compact.sort.uniq
    prepare_hashes_to_save(Url, :url, new_urls)
  end

  ############################
  def migrate_phones_starter #=> PERFECT!
    original_phones = Phone.select(:phone).all.map { |row| row.phone }.uniq.sort
    @phones = original_phones.compact.sort.uniq
    puts @phones.count

    phone_models_hashes = []
    phone_models_hashes.push({ model: 'Core', fields: [:sfdc_ph] })
    phone_models_hashes.push({ model: 'Indexer', fields: [:phone] })
    phone_models_hashes.push({ model: 'Location', fields: [:phone] })
    phone_models_hashes.push({ model: 'Who', fields: [:registrant_phone] })

    phone_models_hashes.each do |model_hash|
      @phones += extract_values(model_hash).compact.sort.uniq
      puts @phones.count
    end

    new_phones = @phones - original_phones
    new_phones.compact.sort.uniq
    prepare_hashes_to_save(Phone, :phone, new_phones)
  end

  ############################
  def migrate_organizations_starter #=> PERFECT!
    original_orgs = Organization.select(:name).all.map { |row| row.name }.uniq.sort
    @orgs = original_orgs.compact.sort.uniq
    puts @orgs.count

    org_models_hashes = []
    org_models_hashes.push({ model: 'Core', fields: [:sfdc_acct] })
    org_models_hashes.push({ model: 'Indexer', fields: [:acct_name] })
    org_models_hashes.push({ model: 'Location', fields: [:geo_acct_name] })
    org_models_hashes.push({ model: 'Who', fields: [:registrant_organization] })

    org_models_hashes.each do |model_hash|
      @orgs += extract_values(model_hash).compact.sort.uniq
      puts @orgs.count
    end

    new_orgs = @orgs - original_orgs
    new_orgs.compact.sort.uniq
    prepare_hashes_to_save(Organization, :name, new_orgs)
  end

  #########################################################
  ### Below 4 Methods used for Url, Phone, Organization ###
  #########################################################

  def get_object_model(model_hash)
    object_model = Object.const_get(model_hash[:model])
  end

  def extract_values(model_hash)
    values_from_model = []
    model = get_object_model(model_hash)
    rows = model.select(model_hash[:fields]).all
    rows.each { |row| model_hash[:fields].each { |field| values_from_model << row.send(field) } }
    values_from_model.compact.sort.uniq
  end

  def prepare_hashes_to_save(model, field, array_of_values)
    hashes_to_save = []
    array_of_values.each { |val| hashes_to_save << { field => val } }
    save_to_db(model, hashes_to_save)
  end

  def save_to_db(model, hashes_to_save)
    model.transaction { hashes_to_save.each { |data_row_hash| model.new(data_row_hash).save } } #=> Very fast!
    # model.create(hashes_to_save) #=> Good, but '#transaction' is much faster!
  end
  #########################################################


  ############################
  # Indexer(:acct_name)
  # Core(:sfdc_acct)
  # Location(:geo_acct_name)
  # Who(:registrant_organization)
  #
  ##########
    # Indexer.select(:id, :raw_url, :clean_url, :acct_name, :phone, :street, :city, :state, :zip, :full_addr, :acct_pin)
    # Core.select(:id, :sfdc_url, :sfdc_clean_url, :sfdc_acct, :sfdc_ph, :sfdc_street, :sfdc_city, :sfdc_state, :sfdc_zip, :full_address, :crm_acct_pin)
    # Location.select(:id, :url, :geo_acct_name, :phone, :street, :city, :state_code, :postal_code, :geo_full_addr, :geo_acct_pin)
    # Who.select(:id, :domain, :registrant_organization, :registrant_phone, :registrant_address, :registrant_city, :registrant_state, :registrant_zip, :who_addr_pin)
  ############################



  ##### NOTES START #####
=begin
  Organization
    name

  Address
    full_addr
    street
    city
    state
    zip
    addr_pin

  Url
    url

  Phone
    phone

    Organization, Address, Url, Phone
=end
  ##### NOTES END #####

end
