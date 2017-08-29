require 'rubygems'
require 'csv'
require 'mechanize'
require 'open-uri'
require 'nokogiri'
require 'uri'
require 'socket'
require 'indexer_helper/rts/rts_manager'
require 'delayed_job'

## Call: WhoisScraper.new.wi_starter
class WhoisScraper
  include InternetConnectionValidator
  include ComplexQueryIterator
  include AddressPinGenerator
  include PhoneFormatter

  def initialize
    puts "\n\n== Welcome to the WhoisScraper Class! ==\n\n"
    @class_pid = Process.pid
    @query_limit = 20 #=> Number of rows per batch in raw_query.

    ## Below are Settings for ComplexQueryIterator Module.
    @dj_wait_time = 3 #=> How often to check dj queue count.
    @dj_count_limit = 0 #=> Num allowed before releasing next batch.
    @number_of_groups = 2 #=> Divide query into groups of x.

    @uri_host = nil
    @record = nil
    @whois_error = nil
  end

  def wi_starter
    generate_query
  end

  def generate_query
    # .where("who_status NOT LIKE '%Error%'")
    raw_query = Indexer
    .select(:id)
    .where("indexer_status != 'Archived'")
    .where(whois_date: nil)

    iterate_raw_query(raw_query) #=> Method is in ComplexQueryIterator.
  end

  #############################################
  ## ComplexQueryIterator takes raw_query and creates series of forked iterations based on limits established above in initialize method.  Then it calls 'template_starter(id)' method.  Module serves as bridge for iteration work.
  #############################################

  ## Call: WhoisScraper.new.wi_starter
  def template_starter(id)
    @indexer = Indexer.find(id)
    # @indexer = Indexer.where(id: id).select(:id, :indexer_status, :clean_url, :whois_date, :who_status).first

    url = @indexer.clean_url
    get_uri_host(url)
    access_whois_directory(url, @uri_host) if @uri_host.present? #=> via InternetConnectionValidator

    if @record.present?
      @whois_result_status = "WI Result"
      parse_whois_record
      @who_addr_pin = generate_pin(@registrant_address, @registrant_zip)
      ip_grabber
      print_parser_results
      save_whois_results
    else
      @whois_result_status = "WI Invalid URL"
      puts "\n\n== #{@whois_error} ==\n\n"
    end

    puts @whois_result_status

    @indexer.update_attributes(indexer_status: "WhoisScraper", who_status: @whois_result_status, whois_date: DateTime.now)

    delay_time = rand(15)
    puts "Delay: #{delay_time}"
    sleep(delay_time)

  end # end indexers iteration

  ##################################
  #### SUPPORTING METHODS BELOW ####
  ##################################

  def get_uri_host(url)
    if url.present?
      begin
        uri = URI(url)
        scheme = uri.scheme
        @uri_host = uri.host
        @uri_host.gsub!("www.", "") if @uri_host.include?("www.")
      rescue
        @uri_host = nil
        @whois_error = "Whois Error: #{$!.message}"
      end
    else
      @uri_host = nil
      @whois_error = "Whois Error: Empty URL"
    end
  end

  ## Call: WhoisScraper.new.wi_starter
  def parse_whois_record
    data = @record.to_s
    @domain_id = space_stripper(data[/Registry Domain ID:(.*)/, 1])
    @registrar_url = space_stripper(data[/Registrar URL:(.*)/, 1])
    @registrant_name = space_stripper(data[/Registrant Name:(.*)/, 1])
    @registrant_organization = space_stripper(data[/Registrant Organization:(.*)/, 1])
    @registrant_address = space_stripper(data[/Registrant Street:(.*)/, 1])
    @registrant_city = space_stripper(data[/Registrant City:(.*)/, 1])
    @registrant_state = space_stripper(data[/Registrant State\/Province:(.*)/, 1])
    @registrant_zip = space_stripper(data[/Registrant Postal Code:(.*)/, 1])
    registrant_phone = data[/Registrant Phone: (.*)/, 1]
    @registrant_phone = phone_formatter(registrant_phone)
    @registrant_email = space_stripper(data[/Registrant Email:(.*)/, 1])
    # @registrar_id = data[/Registrant Name:(.*)/, 1]
    # @registrant_url = data[/Registrant Name:(.*)/, 1]
    servers = data.to_enum(:scan, /Name Server:(.*)/).map { Regexp.last_match }
    if not servers.empty?
      @server1 = space_stripper(servers[0][1])
      @server2 = space_stripper(servers[1][1])
    else
      @server1 = nil
      @server2 = nil
    end
  end

  def ip_grabber
    begin
      host_www = "www.#{@uri_host}"
      @ip = IPSocket::getaddress(host_www)
    rescue
      @ip = nil
      @whois_error = "Whois Error: #{$!.message}"
    end
  end

  def print_parser_results
    puts @domain_id
    puts @registrar_url
    puts @registrant_name
    puts @registrant_organization
    puts @registrant_address
    puts @registrant_city
    puts @registrant_state
    puts @registrant_zip
    puts @registrant_phone
    puts @registrant_email
    puts @ip
    puts @server1
    puts @server2
    puts @who_addr_pin
  end

  ## Call: WhoisScraper.new.wi_starter
  def save_whois_results
    indexer_clean_url = @indexer.clean_url
    Who.find_or_create_by(domain: indexer_clean_url) do |who|
      who.who_status = @whois_result_status
      who.url_status = @whois_result_status
      who.domain = indexer_clean_url
      who.domain_id = @domain_id
      who.ip = @ip
      who.server1 = @server1
      who.server2 = @server2
      who.registrar_url = @registrar_url
      who.who_addr_pin = @who_addr_pin
      who.registrant_name = @registrant_name
      who.registrant_organization = @registrant_organization
      who.registrant_address = @registrant_address
      who.registrant_city = @registrant_city
      who.registrant_zip = @registrant_zip
      who.registrant_state = @registrant_state
      who.registrant_phone = @registrant_phone
      who.registrant_email = @registrant_email
      who.whois_date = DateTime.now
      # who.registrar_id = registrar_id
      # who.registrant_fax = registrant_fax
      # who.registrant_url = registrant_url
    end
  end

  def acct_pin_gen(street, zip)
    if street && zip
      street_parts = street.split(" ")
      street_num = street_parts[0]
      street_num = street_num.tr('^0-9', '')
      new_zip = zip.strip
      new_zip = zip[0..4]
      acct_pin = "z#{new_zip}-s#{street_num}"
    end
  end

  def space_stripper(string)
    if string.present?
      string.strip!
    end
  end

end
