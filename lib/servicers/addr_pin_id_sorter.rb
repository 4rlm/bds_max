## Call: AddrPinIdSorter.new.aps_starter
## Description: ID SORTER METHOD 2: ADDS CORE ID TO INDEXER PIN ARRAY.  Checks for SFDC Core IDs with same Scraped Address Pin as Indexer and saves ID in array in Indexer/Scrapers.
class AddrPinIdSorter
  def initialize
    puts "\n\n== Welcome to the AddrPinIdSorter Class! ==\n\n"
  end

  def aps_starter
    query_target_rows
  end

  def query_target_rows
    cores = Core.select(:sfdc_id, :crm_acct_pin).where.not(crm_acct_pin: nil)
    cores.each { |core| query_compare_rows(core) }
  end

  def query_compare_rows(core)
    indexers = Indexer.select(:acct_pin, :acct_pin_crm_ids).where(archive: false).where(acct_pin: core.crm_acct_pin)
    indexers.each { |indexer| heavy_lifter(indexer, core.sfdc_id)}
  end

  def heavy_lifter(indexer, core_sfdc_id)
    pin_ids = indexer.acct_pin_crm_ids
    pin_ids << core_sfdc_id
    final_array = pin_ids.uniq.sort
    indexer.update_attribute(:acct_pin_crm_ids, final_array)
  end

end
