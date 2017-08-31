## Call: GeoMegaMigrator.new.gm_starter
## Description: Migrates account url, acct, phone, pin, addr, street, city, state, zip from geo to indexer IF indexer rts results are Meta or if account name is nil, based on same clean_url.

## Follow-up: id = @target_row.id #=> 8018 (Indexer.find(8018))
class GeoMegaMigrator
  include CompareAndUpdate

  def initialize
    puts "\n\n== Welcome to the GeoMegaMigrator Class! ==\n\n"
  end

  def gm_starter
    query_target_rows
  end

  def query_target_rows
    indexers = Indexer
      .where(acct_name: [nil, "", " "])
      .or(Indexer.where("acct_name LIKE '%|%'"))
      .or(Indexer.where(rt_sts: ["MS Result", "Meta Result"]))
      .where(archive: false)
      .where.not(clean_url: nil)[0..600]

    indexers.each { |indexer| query_compare_rows(indexer) }
  end

  def query_compare_rows(indexer)
    geos = Location.where(url: indexer.clean_url)
    geos.each { |geo| configure_compare_and_update(indexer, geo) }
  end

  def configure_compare_and_update(target_row, compare_row) #=> via CompareAndUpdate module
    @criteria = ['Meta Result', 'MS Result', 'Error', '|']
    @target_row = target_row
    @compare_row = compare_row

    @manual_update_sets = [
      [:indexer_status, 'GeoMegaMigrator'],
      [:rt_sts, 'GeoMegaMigrator'],
      [:loc_status, 'GeoMegaMigrator']
    ]

    @field_sets = [
      [:clean_url, :url],
      [:acct_name, :geo_acct_name],
      [:acct_pin, :geo_acct_pin],
      [:full_addr, :geo_full_addr],
      [:street, :street],
      [:city, :city],
      [:state, :state_code],
      [:zip, :postal_code]
    ]

    start_compare_and_update #=> via CompareAndUpdate module
  end

end
