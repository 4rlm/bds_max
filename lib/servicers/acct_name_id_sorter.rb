## Call: AcctNameIdSorter.new.ans_starter

## Description: ID SORTER METHOD 3a: ACCOUNT ARRAY MOVER-A.  ADDS CORE ID TO INDEXER ACCT ARRAY  Checks for SFDC Core IDs with same Scraped Account Name as Indexer and saves ID in array in Indexer/Scrapers.

class AcctNameIdSorter

  def initialize
    puts "\n\n== Welcome to the AcctNameIdSorter Class! ==\n\n"
  end

  def ans_starter
    query_target_rows
  end

  def query_target_rows
    cores = Core.select(:sfdc_id, :sfdc_acct).where.not(sfdc_acct: nil)
    cores.each { |core| query_compare_rows(core) }
  end

  def query_compare_rows(core)
    indexers = Indexer.select(:acct_name, :crm_acct_ids).where(archive: false).where(acct_name: core.sfdc_acct)

    indexers.each { |indexer| heavy_lifter(indexer, core.sfdc_id)}
  end

  def heavy_lifter(indexer, core_sfdc_id)
    crm_acct_ids = indexer.crm_acct_ids
    crm_acct_ids << core_sfdc_id
    final_array = crm_acct_ids.uniq.sort
    print_and_update(indexer, final_array)
  end

  def print_and_update(indexer, final_array)
    indexer.update_attribute(:crm_acct_ids, final_array)
    # puts "\ncrm_acct_ids: #{indexer.crm_acct_ids}"
    # puts "final_array: #{final_array}\n\n"
  end

end
