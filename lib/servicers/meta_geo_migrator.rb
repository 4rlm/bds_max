## Call: MetaGeoMigrator.new.gm_starter
## Description: USED AS LAST OPTION!
## For ACCOUNT SCRAPER (Indexer) AS META OR ACCOUNT NAME IS NIL, BUT URL is same as Geo URL. MIGRATES FIELDS BELOW IF FITS CRITERIA.

## Follow-up: id = @target_row.id #=> 8018 (Indexer.find(8018))
class MetaGeoMigrator
  include CompareAndUpdate

  def initialize
    puts "\n\n== Welcome to the MetaGeoMigrator Class! ==\n\n"
  end

  def gm_starter
    query_target_rows
  end

  def query_target_rows
    ## Combined Query:
    # indexers = Indexer.where(archive: false).where.not(clean_url: nil).where(acct_name: nil).or(Indexer.where("acct_name LIKE '%|%'")).or(Indexer.where(rt_sts: ["MS Result", "Meta Result"]))

    ## Segmented Query:
    indexers = Indexer.where(archive: false).where.not(clean_url: nil)
    indexers = indexers.where(rt_sts: ["MS Result", "Meta Result"]).or(indexers.where(acct_name: nil)).or(indexers.where("acct_name LIKE '%|%'"))

    indexers.each { |indexer| query_compare_rows(indexer) }
  end

  def query_compare_rows(indexer)
    geos = Location.where(url: indexer.clean_url)
    geos.each { |geo| configure_compare_and_update(indexer, geo) }
  end

  def configure_compare_and_update(target_row, compare_row) #=> via CompareAndUpdate module
    puts target_row.inspect

    @criteria = ['Meta Result', 'MS Result', 'Error', '|']
    @target_row = target_row
    @compare_row = compare_row

    @manual_update_sets = [
      [:indexer_status, 'MetaGeoMigrator'],
      [:rt_sts, 'MetaGeoMigrator'],
      [:geo_status, 'MetaGeoMigrator']
    ]

    @field_sets = [
      [:acct_name, :geo_acct_name],
      [:acct_pin, :geo_acct_pin],
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
