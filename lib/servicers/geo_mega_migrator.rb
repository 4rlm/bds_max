## Call: GeoMegaMigrator.new.gm_starter
## Description: Migrates account url, acct, phone, pin, addr, street, city, state, zip from geo to indexer IF indexer rts results are Meta or if account name is nil, based on same clean_url.

class GeoMegaMigrator
  include ComplexQueryIterator

  def initialize
    puts "\n\n== Welcome to the GeoMegaMigrator Class! ==\n\n"
    @criteria = ['Meta Result', 'MS Result', 'Error', '|']
  end

  def gm_starter
    indexers = Indexer.where(acct_name: [nil, "", " "]).or(Indexer.where("acct_name LIKE '%|%'")).or(Indexer.where(rt_sts: ["MS Result", "Meta Result"])).where(archive: false).where.not(clean_url: nil)[328..1000]

    counter = 0
    indexers.each do |indexer|
      counter+=1
      puts "\n\n#{counter}#{"-"*30}"

      geos = Location.where(url: indexer.clean_url)
      geos.each do |geo|
        # counter+=1
        # puts "\n\n#{counter}#{"-"*30}"
        # printer("url", indexer.clean_url, geo.url)
        # printer("acct", indexer.acct_name, geo.geo_acct_name)
        # printer("phone", indexer.phone, geo.phone)
        # printer("pin", indexer.acct_pin, geo.geo_acct_pin)
        # printer("addr", indexer.full_addr, geo.geo_full_addr)

        #### Works Below!! ###
        # if @found_data_difference
        #   puts "@found_data_difference"

          # indexer.update_attributes(indexer_status: "GeoMegaMigrator", geo_status: "GeoMegaMigrator", acct_name: geo.geo_acct_name, phone: geo.phone, acct_pin: geo.geo_acct_pin, full_addr: geo.geo_full_addr, street: geo.street, city: geo.city, state: geo.state_code, zip: geo.postal_code)
        # else
        #   puts "No - @found_data_difference"
        # end

        ### Testing Below ###
        @target_row = indexer
        @compare_row = geo
        @update_hash = {}

        compare_fields("clean_url", "url")
        compare_fields("acct_name", "geo_acct_name")
        compare_fields("acct_pin", "geo_acct_pin")
        compare_fields("full_addr", "geo_full_addr")

      end
    end

  end

  ### Testing Below ###

  # id = @target_row.id #=> 8018
  def compare_fields(target_field, compare_field)
    target_attr = @target_row.send(target_field)
    compare_attr = @compare_row.send(compare_field)

    if (target_attr == nil || @criteria.any? { |rule| target_attr.include?(rule) }) && compare_attr.present? && target_attr != compare_attr
      puts "#{target_field}: #{target_attr}"
      puts "#{compare_field}: #{compare_attr}"

      @update_hash[target_field.to_sym] = compare_attr
      compare_addr_fields if target_field == "full_addr" || target_field == "acct_pin"

      binding.pry
    end

  end

  def compare_addr_fields
    compare_fields("street", "street")
    compare_fields("city", "city")
    compare_fields("state", "state_code")
    compare_fields("zip", "postal_code")
  end



########################################################
  ### Notes: ####
  # @update_hash[:acct_name] = 'sample'
  # @update_hash[:phone] = 'sample'
  # @target_row.update_attributes(@update_hash)

  ### Works below!!! ###
  # def printer(target_field, comparing_field)
  #   id = @target_row.id #=> 8018
  #   sample = @target_row.send(target_field)
  #   @update_hash = {}
  #
  #   if id == 8018
  #     target_sym = target_field.to_sym
  #
  #     @update_hash[:acct_name] = 'sample'
  #     @update_hash[:phone] = 'sample'
  #     # @target_row.update_attributes(@update_hash)
  #     binding.pry
  #
  #   end
  # end

### Works below!!! ###
  # def printer(category, input_a, input_b)
  #   if (input_a == nil || @criteria.any? { |rule| input_a.include?(rule) }) && input_b.present? && input_a != input_b
  #     puts "#{category}: #{input_a}"
  #     puts "#{category}: #{input_b}"
  #     @found_data_difference = true
  #   else
  #     puts "False"
  #   end
  # end

end
