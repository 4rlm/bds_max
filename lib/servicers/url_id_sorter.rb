## Call: UrlIdSorter.new.us_starter
## Description: ID SORTER METHOD 1: ADDS CORE ID TO INDEXER URL ARRAY.  Checks for SFDC Core IDs with same Scraped URL as Indexer and saves ID in array in Indexer/Scrapers.

class UrlIdSorter

  def initialize
    puts "\n\n== Welcome to the UrlIdSorter Class! ==\n\n"
  end

  def us_starter
    query_target_rows
  end

  def query_target_rows
    cores = Core.select(:sfdc_id, :sfdc_clean_url).where.not(sfdc_clean_url: nil)
    cores.each { |core| query_compare_rows(core) }
  end

  def query_compare_rows(core)
    sfdc_clean_url = core.sfdc_clean_url
    if sfdc_clean_url != "http://" && sfdc_clean_url != "https://"
      indexers = Indexer.select(:clean_url, :clean_url_crm_ids).where(archive: false).where(clean_url: sfdc_clean_url)

      indexers.each { |indexer| heavy_lifter(indexer, core.sfdc_id)}
    end
  end

  def heavy_lifter(indexer, core_sfdc_id)
    url_ids = indexer.clean_url_crm_ids
    url_ids << core_sfdc_id
    final_array = url_ids.uniq.sort
    print_and_update(indexer, final_array)
  end

  def print_and_update(indexer, final_array)
    indexer.update_attribute(:clean_url_crm_ids, final_array)
    # puts "\nclean_url_crm_ids: #{indexer.clean_url_crm_ids}"
    # puts "final_array: #{final_array}\n\n"
  end

end
