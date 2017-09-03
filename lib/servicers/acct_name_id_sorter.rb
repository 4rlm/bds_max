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
    cores.each do |core|
      core_sfdc_id = core.sfdc_id
      core_sfdc_acct = core.sfdc_acct

      query_compare_rows(core_sfdc_id, core_sfdc_acct)
    end
  end

  def query_compare_rows(core_sfdc_id, core_sfdc_acct)
    indexers = Indexer.select(:acct_name, :crm_acct_ids).where(archive: false).where.not(acct_name: nil)

    indexers.each { |indexer| acct_squeezer_processor(indexer, core_sfdc_id, core_sfdc_acct) }
  end

  def acct_squeezer_processor(indexer, core_sfdc_id, core_sfdc_acct)
    sqz_core_acct = acct_squeezer(core_sfdc_acct)
    sqz_indexer_acct = acct_squeezer(indexer.acct_name)

    heavy_lifter(indexer, core_sfdc_id) if (sqz_core_acct && sqz_indexer_acct) && sqz_core_acct == sqz_indexer_acct
  end

  def acct_squeezer(org)
    squeezed_org = org.downcase
    squeezed_org = squeezed_org.gsub(/[^A-Za-z]/, "")
    squeezed_org.strip!
    squeezed_org
  end

  def heavy_lifter(indexer, core_sfdc_id)
    crm_acct_ids = indexer.crm_acct_ids
    crm_acct_ids << core_sfdc_id
    final_array = crm_acct_ids.uniq.sort
    indexer.update_attribute(:crm_acct_ids, final_array)
  end

end


########### ORIGINAL ###########
# ## Call: AcctNameIdSorter.new.ans_starter
# ## Description: ID SORTER METHOD 3a: ACCOUNT ARRAY MOVER-A.  ADDS CORE ID TO INDEXER ACCT ARRAY  Checks for SFDC Core IDs with same Scraped Account Name as Indexer and saves ID in array in Indexer/Scrapers.
# class AcctNameIdSorter
#   def initialize
#     puts "\n\n== Welcome to the AcctNameIdSorter Class! ==\n\n"
#   end
#
#   def ans_starter
#     query_target_rows
#   end
#
#   def query_target_rows
#     cores = Core.select(:sfdc_id, :sfdc_acct).where.not(sfdc_acct: nil)
#     cores.each { |core| query_compare_rows(core) }
#   end
#
#   def query_compare_rows(core)
#     indexers = Indexer.select(:acct_name, :crm_acct_ids).where(archive: false).where(acct_name: core.sfdc_acct)
#     indexers.each { |indexer| heavy_lifter(indexer, core.sfdc_id)}
#   end
#
#   def heavy_lifter(indexer, core_sfdc_id)
#     crm_acct_ids = indexer.crm_acct_ids
#     crm_acct_ids << core_sfdc_id
#     final_array = crm_acct_ids.uniq.sort
#     indexer.update_attribute(:crm_acct_ids, final_array)
#   end
#
# end
