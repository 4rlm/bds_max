########### TESTING ###########

## Call: GeoPhoneMigrator.new.gp_starter
## Description: Migrates geo phone to Indexer if indexer phone is nil, and indexer and geo share same clean_url.
class GeoPhoneMigrator
  include CompareAndUpdate

  def initialize
    puts "\n\n== Welcome to the GeoPhoneMigrator Class! ==\n\n"
  end

  def gp_starter
    query_target_rows
  end

  # def letters_in_phone(phone)
  #   result = nil
  #   if phone
  #     result = phone.scan(/[A-Za-z]/).join
  #     if result == ''
  #       result = nil
  #     end
  #   end
  #   result
  # end

  def query_target_rows
    indexers = Indexer
      .where(phone: [nil, 'Meta Result', 'MS Result', 'Error', '(999) 999-9999', ''])
      .where(archive: false)
      .where.not(geo_status: "GeoPhoneMigrator", clean_url: nil)

    indexers.each { |indexer| query_compare_rows(indexer) }
  end

  def query_compare_rows(indexer)
    geos = Location
      .where.not(phone: nil)
      .where(url: indexer.clean_url)

    geos.each do |geo|
      if not indexer.acct_pin.present? || indexer.acct_pin == geo.geo_acct_pin
        binding.pry
        configure_compare_and_update(indexer, geo)
      end
    end
  end


  def configure_compare_and_update(target_row, compare_row) #=> via CompareAndUpdate module
    @target_row = target_row
    @compare_row = compare_row
    @criteria = ['Meta Result', 'MS Result', 'Error', '(999) 999-9999', '']

    @manual_update_sets = [
      [:indexer_status, 'GeoPhoneMigrator'],
      [:geo_status, 'GeoPhoneMigrator']
    ]

    @field_sets = [[:phone, :phone]]

    start_compare_and_update #=> via CompareAndUpdate module
  end

end
################################



########### ORIGINAL ###########
# ## Call: GeoPhoneMigrator.new.gp_starter
# ## Description: Migrates geo phone to Indexer if indexer phone is nil, and indexer and geo share same clean_url.
# class GeoPhoneMigrator
#   include ComplexQueryIterator
#
#   def initialize
#     puts "\n\n== Welcome to the GeoPhoneMigrator Class! ==\n\n"
#   end
#
#   def gp_starter
#     indexers = Indexer.where(phone: [nil, "(999) 999-9999"]).where(archive: false).where.not(geo_status: "GeoPhoneMigrator", clean_url: nil)
#
#     counter = 0
#     indexers.each do |indexer|
#       ind_url = indexer.clean_url
#       ind_phone = indexer.phone
#       ind_pin = indexer.acct_pin
#
#       geos = Location.where.not(phone: nil).where(url: ind_url)
#
#       geos.each do |geo|
#         geo_url = geo.url
#         geo_phone = geo.phone
#         geo_pin = geo.geo_acct_pin
#
#         if not ind_pin.present? || geo_pin == ind_pin
#           counter+=1
#           puts "\n\n#{counter}#{"-"*30}"
#           puts "ind_url: #{ind_url}"
#           puts "geo_url: #{geo_url}"
#           puts "ind_pin: #{ind_pin}"
#           puts "geo_pin: #{geo_pin}\n\n"
#           puts "ind_phone: #{ind_phone}"
#           puts "geo_phone: #{geo_phone}\n\n"
#
#           indexer.update_attributes(indexer_status: "GeoPhoneMigrator", geo_status: "GeoPhoneMigrator", phone: geo_phone)
#         else
#           puts "Skipped"
#         end
#
#       end
#
#     end
#   end
#
# end
