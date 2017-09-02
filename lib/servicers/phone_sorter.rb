## Call: PhoneSorter.new.ps_starter

## Description: ID SORTER METHOD 4: PHONE ARRAY MOVER (EXPRESS).  ADDS CORE ID TO INDEXER PH ARRAY.  Checks for SFDC Core IDs with same Scraped Phone as Indexer and saves ID in array in Indexer/Scrapers.

class PhoneSorter

  def initialize
    puts "\n\n== Welcome to the PhoneSorter Class! ==\n\n"
  end

  def ps_starter
    query_target_rows
  end

  def query_target_rows
    cores = Core.select(:sfdc_id, :sfdc_ph).where.not(sfdc_ph: nil)
    cores.each { |core| query_compare_rows(core) }
  end

  def query_compare_rows(core)
    indexers = Indexer.select(:phone, :crm_acct_ids).where(archive: false).where(phone: core.sfdc_ph)

    indexers.each { |indexer| heavy_lifter(indexer, core.sfdc_id)}
  end

  def heavy_lifter(indexer, core_sfdc_id)
    crm_ph_ids = indexer.crm_ph_ids
    crm_ph_ids << core_sfdc_id
    final_array = crm_ph_ids.uniq.sort
    print_and_update(indexer, final_array)
  end

  def print_and_update(indexer, final_array)
    puts "\ncrm_ph_ids: #{indexer.crm_ph_ids}"
    puts "final_array: #{final_array}\n\n"
    # indexer.update_attribute(:crm_ph_ids, final_array)
  end

end
