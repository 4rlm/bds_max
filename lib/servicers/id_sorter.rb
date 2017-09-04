## Call: IdSorter.new.id_starter
## Description: ID SORTER METHOD 3a: ACCOUNT ARRAY MOVER-A.  ADDS CORE ID TO INDEXER ACCT ARRAY  Checks for SFDC Core IDs with same Scraped Account Name as Indexer and saves ID in array in Indexer/Scrapers.
require 'delayed_job'


class IdSorter
  def initialize
    puts "\n\n#{"="*40}\n== Starting IdSorter Finalizer ==\nEntire Process can take 30-60 Minutes!!\nVery Important Process required to later create matching scores for scraped accounts vs crm accounts.\nAdds Core sfdc_id to Indexer :crm_acct_ids, crm_ph_ids, acct_pin_crm_ids or clean_url_crm_ids\nIf same url, acct name, phone, or addr_pin.\nNOTE: First deletes all stored ids from respective db arrays, to ensure non-contamination (if data has changed since prior scrape.)\n#{"="*40}\n"
  end

  def id_starter
    generate_queries
  end

  def generate_queries

    core_field_sets = [[:sfdc_id],
                      [:sfdc_acct],
                      [:sfdc_ph],
                      [:crm_acct_pin],
                      [:sfdc_clean_url]]

    indexer_field_sets = [[:acct_name, :crm_acct_ids],
                          [:phone, :crm_ph_ids],
                          [:acct_pin, :acct_pin_crm_ids],
                          [:clean_url, :clean_url_crm_ids]]

    cores = Core.select(unpack_field_sets(core_field_sets))
    indexers = Indexer.select(unpack_field_sets(indexer_field_sets)).where(archive: false)
    cores.each { |core| indexers.each { |indexer| compare_rows(core, indexer) } }
  end

  def unpack_field_sets(field_sets)
    query_fields = []
    field_sets.each { |field| query_fields << field[0] }
  end

  def check_array_includes_id(core_sfdc_id, indexer, id_array_sym)
    id_array = indexer.send(id_array_sym)
    (id_array && id_array.include?(core_sfdc_id)) ? true : false
  end

  def compare_rows(core, indexer)
    @update_hash = {}

    if (core.sfdc_acct && indexer.acct_name) && (check_array_includes_id(core.sfdc_id, indexer, :crm_acct_ids) == false)
      core.sfdc_acct == indexer.acct_name ? heavy_lifter(core.sfdc_id, indexer, :crm_acct_ids) : compare_sqz_acct(core, indexer, :crm_acct_ids)
    end

    if (core.sfdc_ph && indexer.phone) && (check_array_includes_id(core.sfdc_id, indexer, :crm_ph_ids) == false)
      core.sfdc_ph == indexer.phone ? heavy_lifter(core.sfdc_id, indexer, :crm_ph_ids) : compare_sqz_phone(core, indexer, :crm_ph_ids)
    end

    if (core.crm_acct_pin && indexer.acct_pin) && (check_array_includes_id(core.sfdc_id, indexer, :acct_pin_crm_ids) == false)
      heavy_lifter(core.sfdc_id, indexer, :acct_pin_crm_ids) if core.crm_acct_pin == indexer.acct_pin
    end

    if (core.sfdc_clean_url && indexer.clean_url) && (check_array_includes_id(core.sfdc_id, indexer, :clean_url_crm_ids) == false) && (core.sfdc_clean_url != "http://" && core.sfdc_clean_url != "https://")
      heavy_lifter(core.sfdc_id, indexer, :clean_url_crm_ids) if core.sfdc_clean_url == indexer.clean_url
    end

    indexer.update_attributes(@update_hash) if not @update_hash.empty?
  end

  def heavy_lifter(core_sfdc_id, indexer, id_array_sym)
    id_array = indexer.send(id_array_sym)
    id_array << core_sfdc_id
    final_array = id_array.uniq.sort
    @update_hash[id_array_sym.to_sym] = final_array
  end

  def compare_sqz_phone(core, indexer, id_array_sym)
    core_phone_sqz = phone_squeezer(core.sfdc_ph)
    indexer_phone_sqz = phone_squeezer(indexer.phone)
    heavy_lifter(core.sfdc_id, indexer, id_array_sym) if (core_phone_sqz == indexer_phone_sqz)
  end

  def compare_sqz_acct(core, indexer, id_array_sym)
    core_acct_sqz = acct_squeezer(core.sfdc_acct)
    indexer_acct_sqz = acct_squeezer(indexer.acct_name)
    heavy_lifter(core.sfdc_id, indexer, id_array_sym) if (core_acct_sqz == indexer_acct_sqz)
  end

  def acct_squeezer(org)
    squeezed_org = org.downcase
    squeezed_org = squeezed_org.gsub(/[^A-Za-z0-9]/, "")
    squeezed_org.strip!
    squeezed_org
  end

  def phone_squeezer(phone)
    squeezed_phone = phone.downcase
    squeezed_phone = squeezed_phone.gsub(/[^0-9]/, "")
    squeezed_phone.strip!
    squeezed_phone
  end

end
