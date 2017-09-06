## Call: TableDbMigrator.new.td_starter
## Description: Read below.  Handles entire id sorting finalizer.  Replaces AcctNameIdSorter, PhoneIdSorter, AddrPinIdSorter, UrlIdSorter.

class TableDbMigrator

  def initialize
    # puts "\n\n#{"="*40}\n== Starting TableDbMigrator ==\nMigrates Organization, Address, Url, Phone from Core, Indexer, Location, Who\nAll relevant data will be stored in these common db tables, rather than in the old separate system.\nTHERE SHOULD BE NO DUPLICATES ANYWHERE IN ENTIRE DB!!\n#{"="*40}\n"

    # @update_hash = {}
  end

  def td_starter
    # generate_queries
    get_urls
  end

  ############################
  def get_urls
    original_urls = Url.select(:url).where.not(url: nil).map { |row| row.url }.uniq.sort
    @urls = original_urls
    extract_urls(Core, :sfdc_url)
    extract_urls(Core, :sfdc_clean_url)
    extract_urls(Indexer, :raw_url)
    extract_urls(Indexer, :clean_url)
    extract_urls(Location, :url)
    extract_urls(Who, :domain)

    new_urls = @urls - original_urls
    save_to_db(new_urls)
  end

  def extract_urls(model, field)
    @urls += model.select(field.to_sym).where.not("#{field}": nil).map { |row| row.send(field) }.uniq.sort
    puts @urls.count
  end

  def save_to_db(new_urls)
    urls_to_add = []
    new_urls.each { |new_url| urls_to_add << { :url => new_url } }
    # Url.create(urls_to_add) #=> Good option, but below is much faster!
    Url.transaction { urls_to_add.each { |hash| Url.new(hash).save } } #=> Very fast!
  end
  ############################




  # def generate_queries
  #   indexers = Indexer.select(:id, :raw_url, :clean_url, :acct_name, :phone, :street, :city, :state, :zip, :full_addr, :acct_pin)
  #   indexers.each { |indexer| extract_indexers(indexer) }
  #
  #
  #   cores = Core.select(:id, :sfdc_url, :sfdc_clean_url, :sfdc_acct, :sfdc_ph, :sfdc_street, :sfdc_city, :sfdc_state, :sfdc_zip, :full_address, :crm_acct_pin)
  #
  #   locations = Location.select(:id, :url, :geo_acct_name, :phone, :street, :city, :state_code, :postal_code, :geo_full_addr, :geo_acct_pin)
  #
  #   whos = Who.select(:id, :domain, :registrant_organization, :registrant_phone, :registrant_address, :registrant_city, :registrant_state, :registrant_zip, :who_addr_pin)
  # end


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
