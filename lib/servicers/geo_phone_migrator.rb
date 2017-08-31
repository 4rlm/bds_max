## Call: GeoPhoneMigrator.new.gp_starter
## Description: Migrates geo phone to Indexer if indexer phone is nil, and indexer and geo share same clean_url.
class GeoPhoneMigrator
  include ComplexQueryIterator

  def initialize
    puts "\n\n== Welcome to the GeoPhoneMigrator Class! ==\n\n"
  end

  def gp_starter
    indexers = Indexer.where(phone: [nil, "(999) 999-9999"]).where(archive: false).where.not(geo_status: "GeoPhoneMigrator", clean_url: nil)

    counter = 0
    indexers.each do |indexer|
      ind_url = indexer.clean_url
      ind_phone = indexer.phone
      ind_pin = indexer.acct_pin

      geos = Location.where.not(phone: nil).where(url: ind_url)

      geos.each do |geo|
        geo_url = geo.url
        geo_phone = geo.phone
        geo_pin = geo.geo_acct_pin

        if not ind_pin.present? || geo_pin == ind_pin
          counter+=1
          puts "\n\n#{counter}#{"-"*30}"
          puts "ind_url: #{ind_url}"
          puts "geo_url: #{geo_url}"
          puts "ind_pin: #{ind_pin}"
          puts "geo_pin: #{geo_pin}\n\n"
          puts "ind_phone: #{ind_phone}"
          puts "geo_phone: #{geo_phone}\n\n"

          indexer.update_attributes(indexer_status: "GeoPhoneMigrator", geo_status: "GeoPhoneMigrator", phone: geo_phone)
        else
          puts "Skipped"
        end

      end

    end
  end

end
