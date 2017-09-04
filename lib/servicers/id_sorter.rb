## Call: IdSorter.new.id_starter
## Description: ID SORTER METHOD 3a: ACCOUNT ARRAY MOVER-A.  ADDS CORE ID TO INDEXER ACCT ARRAY  Checks for SFDC Core IDs with same Scraped Account Name as Indexer and saves ID in array in Indexer/Scrapers.
class IdSorter
  def initialize
    puts "\n\n== Welcome to the IdSorter Class! ==\n\n"

    @core_field_sets = [
      [:sfdc_id],
      [:sfdc_acct],
      [:sfdc_ph],
      [:crm_acct_pin],
      [:sfdc_clean_url]]

    @indexer_field_sets = [
      [:acct_name, :crm_acct_ids],
      [:phone, :crm_ph_ids],
      [:acct_pin, :acct_pin_crm_ids],
      [:clean_url, :clean_url_crm_ids]]
  end

  def id_starter
    cores = Core.select(generate_query(@core_field_sets))
    indexers = Indexer.select(generate_query(@indexer_field_sets)).where(archive: false)
    start_iterations(cores, indexers)
  end

  def generate_query(field_sets)
    query_fields = []
    field_sets.each { |field| query_fields << field[0] }
  end

  def start_iterations(cores, indexers)
    cores.each do |core|
      indexers.each { |indexer| compare_rows(core, indexer) }
    end
  end

  def compare_rows(core, indexer)

    if core.sfdc_acct == indexer.acct_name
      print_this(core.sfdc_acct, indexer.acct_name)
      heavy_lifter(core.sfdc_id, indexer, :crm_acct_ids)
    end

    if core.sfdc_ph == indexer.phone
      print_this(core.sfdc_ph, indexer.phone)
      heavy_lifter(core.sfdc_id, indexer, :crm_ph_ids)
    end

    if core.crm_acct_pin == indexer.acct_pin
      print_this(core.crm_acct_pin, indexer.acct_pin)
      heavy_lifter(core.sfdc_id, indexer, :acct_pin_crm_ids)
    end

    if core.sfdc_clean_url == indexer.clean_url
      print_this(core.sfdc_clean_url, indexer.clean_url)
      heavy_lifter(core.sfdc_id, indexer, :clean_url_crm_ids)
    end

  end

  def print_this(one, two)
    puts one
    puts two
  end


  def heavy_lifter(core_sfdc_id, indexer, id_array_sym)
    id_array = indexer.send(id_array_sym)
    id_array << core_sfdc_id
    final_array = id_array.uniq.sort
    puts id_array
    puts final_array
    # indexer.update_attribute(id_array_sym.to_sym, final_array)
    # binding.pry
  end


  # def query_target_rows
  #   cores = Core.select(:sfdc_id, :sfdc_acct).where.not(sfdc_acct: nil)
  #   cores.each do |core|
  #     core_sfdc_id = core.sfdc_id
  #     core_sfdc_acct = core.sfdc_acct
  #
  #     query_compare_rows(core_sfdc_id, core_sfdc_acct)
  #   end
  # end

  # def query_compare_rows(core_sfdc_id, core_sfdc_acct)
  #   indexers = Indexer.select(:acct_name, :crm_acct_ids).where(archive: false).where.not(acct_name: nil)
  #
  #   indexers.each { |indexer| acct_squeezer_processor(indexer, core_sfdc_id, core_sfdc_acct) }
  # end

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

end
