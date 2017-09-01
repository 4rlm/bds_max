## Call: CleanGeoMigrator.new.af_starter
## Description: for filling holes and formatting of good indexers.
## Migrates full_addr, street, city, state, zip, phone from geo to indexer
## IF clean_url AND acct pin match.

class CleanGeoMigrator
  include CompareAndUpdate

  def initialize
    puts "\n\n== Welcome to the CleanGeoMigrator Class! ==\n\n"
  end

  def af_starter
    query_target_rows
  end

  def query_target_rows
    # .where("acct_name ~* ?", '^A').count #=> Regex / regex
    # .where("acct_name ~* ?", '^\d').count #=> Regex / regex
    indexers = Indexer.where(archive: false).where.not(clean_url: nil, acct_pin: nil).where.not(indexer_status: ['CleanGeoMigrator', 'MetaGeoMigrator']).where.not(rt_sts: ['CleanGeoMigrator', 'MetaGeoMigrator']).where.not(geo_status: ['CleanGeoMigrator', 'MetaGeoMigrator'])

    indexers.each { |indexer| query_compare_rows(indexer) }
  end

  def query_compare_rows(indexer)
    geos = Location.where(geo_acct_pin: indexer.acct_pin, url: indexer.clean_url)
    geos.each { |geo| configure_compare_and_update(indexer, geo) }
  end

  def configure_compare_and_update(target_row, compare_row) #=> via CompareAndUpdate module
    # @criteria = ['Meta Result', 'MS Result', 'Error', '|']
    @criteria = nil
    @target_row = target_row
    @compare_row = compare_row

    @manual_update_sets = [
      [:indexer_status, 'CleanGeoMigrator'],
      [:rt_sts, 'CleanGeoMigrator'],
      [:geo_status, 'CleanGeoMigrator']
    ]

    @field_sets = [
      [:acct_name, :geo_acct_name],
      [:full_addr, :geo_full_addr],
      [:street, :street],
      [:city, :city],
      [:state, :state_code],
      [:zip, :postal_code],
      [:phone, :phone]
    ]

    start_compare_and_update #=> via CompareAndUpdate module
  end

end
