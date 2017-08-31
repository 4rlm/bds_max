## Call: GeoMegaMigrator.new.gm_starter
## Description: Migrates account url, acct, phone, pin, addr, street, city, state, zip from geo to indexer IF indexer rts results are Meta or if account name is nil, based on same clean_url.

## Follow-up: id = @target_row.id #=> 8018 (Indexer.find(8018))
class GeoMegaMigrator
  include CompareAndUpdate

  def initialize
    puts "\n\n== Welcome to the GeoMegaMigrator Class! ==\n\n"
    @criteria = ['Meta Result', 'MS Result', 'Error', '|']
  end

  def gm_starter
    indexers = Indexer.where(acct_name: [nil, "", " "]).or(Indexer.where("acct_name LIKE '%|%'")).or(Indexer.where(rt_sts: ["MS Result", "Meta Result"])).where(archive: false).where.not(clean_url: nil)[500..700]

    counter = 0
    indexers.each do |indexer|
      @target_row = indexer
      counter+=1
      puts "\n\n#{counter}#{"-"*30}"

      geos = Location.where(url: @target_row.clean_url)
      geos.each do |geo|
        @compare_row = geo
        # counter+=1
        # puts "\n\n#{counter}#{"-"*30}"

        start_compare_and_update #=> via CompareAndUpdate module
        # update_db #=> via CompareAndUpdate module
      end
    end

  end

  def setup_fields
    ## compare_fields #=> via CompareAndUpdate module
    @update_hash = {}
    compare_fields("clean_url", "url")
    compare_fields("acct_name", "geo_acct_name")
    compare_fields("acct_pin", "geo_acct_pin")
    setup_conditional_fields if compare_fields("full_addr", "geo_full_addr")
  end

  def setup_conditional_fields
    ### Fields only compared if triggered by change in parent field.
    ## compare_fields #=> via CompareAndUpdate module
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
