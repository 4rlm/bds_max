## Call: ScoreCalculatorFinalizer.new.sc_starter
## Description:
# require 'delayed_job'

class ScoreCalculatorFinalizer

  def initialize
    puts "\n\n#{"="*40}STARTING INDEXER SCORE CALCULATOR: Core SFDC ID in each Scraped Record gets scored based on how many matching fields of 4 (url, address pin, phone, org name) and each SFDC ID gets a Matching Score (25%, 50%, 75%, 100%) .\n\n"
  end

  def sc_starter
    # reset_db_id_arrays
    generate_queries
  end

  def reset_db_id_arrays
    puts "\n\n== Deleting all stored Core sfdc_ids in Indexer :crm_acct_ids, crm_ph_ids, acct_pin_crm_ids or clean_url_crm_ids\n\nThis will prevent contamination and errors if data has changed since prior scraping. ==\n\n"
    indexers = Indexer.select(:score100, :score75, :score50, :score25)
    indexers.update_all(score100: [], score75: [], score50: [], score25: [])
  end

  def generate_queries
    indexers = Indexer.where(archive: false).where.not(clean_url_crm_ids: []).or(Indexer.where.not(crm_acct_ids: [])).or(Indexer.where.not(acct_pin_crm_ids: [])).or(Indexer.where.not(crm_ph_ids: []))
    indexers.each { |indexer| calculate_score(indexer) }
  end

  def calculate_score(indexer)
    scores =  {score100: [], score75: [], score50: [], score25: []}
    ids = indexer.clean_url_crm_ids + indexer.crm_acct_ids + indexer.acct_pin_crm_ids + indexer.crm_ph_ids

    uniqs = ids.uniq
    uniqs.each do |uniq_id|
      num = ids.select {|id| uniq_id == id}.length
      case num
      when 4 then scores[:score100] << uniq_id
      when 3 then scores[:score75] << uniq_id
      when 2 then scores[:score50] << uniq_id
      when 1 then scores[:score25] << uniq_id
        puts uniq_id
      end
    end

    puts "\n\n----------------"
    puts scores.inspect
    puts ids.inspect
    indexer.update_attributes(scores)
  end

end
