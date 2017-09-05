## Call: UltimateMigratorFinalizer.new.um_starter
## Description:
# require 'delayed_job'

class UltimateMigratorFinalizer

  def initialize
    puts "\n\n#{"="*40}STARTING INDEXER SCRAPER MIGRATOR: Migrates final sorted and scored Indexer Data to Core account based on Match Score and ranked by hierarchy. If two indexers have same match score, the priority goes to those with the order of matching url, then account name, then phone, then address pin.\n\n"
  end

  def um_starter
    # reset_db_id_arrays
    generate_queries
  end

  ### ORIGINAL ###
  def generate_queries
    p1_indexers = Indexer.where(archive: false).where.not("clean_url_crm_ids = '{}'")
    by_score(p1_indexers, :clean_url_crm_ids)

    p2_indexers =  Indexer.where(archive: false).where.not("crm_acct_ids = '{}'")
    by_score(p2_indexers, :crm_acct_ids)

    p3_indexers =  Indexer.where(archive: false).where.not("crm_ph_ids = '{}'")
    by_score(p3_indexers, :crm_ph_ids)

    p4_indexers =  Indexer.where(archive: false).where.not("acct_pin_crm_ids = '{}'")
    by_score(p4_indexers, :acct_pin_crm_ids)

    p5_indexers =  Indexer.where(archive: false).where("clean_url_crm_ids = '{}'").where("crm_acct_ids = '{}'").where("crm_ph_ids = '{}'").where("acct_pin_crm_ids = '{}'")
    by_score(p5_indexers, :id, false)
  end

  def by_score(indexers, col, priority=true)
    indexers.each do |indexer|
      s100 = indexer.score100
      s75 = indexer.score75
      s50 = indexer.score50
      s25 = indexer.score25

      if s100.any?
        good_ids = priority ? grab_good_ids(indexer.send(col), s100) : s100
        update_core(indexer, good_ids, "100%", "Ready")
      end

      if s75.any?
        good_ids = priority ? grab_good_ids(indexer.send(col), s75) : s75
        update_core(indexer, good_ids, "75%", "Ready")
      end

      if s50.any?
        good_ids = priority ? grab_good_ids(indexer.send(col), s50) : s50
        update_core(indexer, good_ids, "50%", "Ready")
      end

      if s25.any?
        good_ids = priority ? grab_good_ids(indexer.send(col), s25) : s25
        update_core(indexer, good_ids, "25%", "Ready")
      end

    end
  end # End by_score

  # Helper method for 'by_score'
  def grab_good_ids(clean_url_crm_ids, score_ids)
    clean_url_crm_ids.select { |sfdc_id| score_ids.include?(sfdc_id) }
  end

  def grab_none_rejects(dropped_ids, ids)
    ids.reject { |sfdc_id| dropped_ids.include?(sfdc_id) }
  end

  #  Helper method for `by_score`
  def update_core(indexer, ids, score, status)
    return if ids.empty?
    good_ids = grab_none_rejects(indexer.dropped_ids, ids)
    cores = Core.where(sfdc_id: good_ids).where(acct_merge_sts: [nil, "Drop", "Ready"])

    cores.each do |core|
      if compare_score(core.match_score, score)
        new_values = {
          staff_pf_sts: indexer.stf_status,
          loc_pf_sts: indexer.loc_status,
          staff_link: indexer.staff_url,
          staff_text: indexer.staff_text,
          location_link: indexer.location_url,
          location_text: indexer.location_text,
          staffer_sts: indexer.stf_status,
          template: indexer.template,
          who_sts: indexer.who_status,
          match_score: score,
          # acct_match_sts: compare_core_indexer(core.sfdc_acct, indexer.acct_name),
          acct_match_sts: compare_acct_downcase(core.sfdc_acct, indexer.acct_name),
          ph_match_sts: compare_core_indexer(core.sfdc_ph, indexer.phone),
          pin_match_sts: compare_core_indexer(core.crm_acct_pin, indexer.acct_pin),
          url_match_sts: compare_core_indexer(core.sfdc_clean_url, indexer.clean_url),
          alt_acct_pin: indexer.acct_pin,
          alt_acct: indexer.acct_name,
          alt_street: indexer.street,
          alt_city: indexer.city,
          alt_state: indexer.state,
          alt_zip: indexer.zip,
          alt_ph: indexer.phone,
          alt_url: indexer.clean_url,
          alt_source: "Web",
          alt_address: indexer.full_addr,
          alt_template: indexer.template,
          acct_merge_sts: status,
          web_staff_count: indexer.web_staff_count
        }

        puts "\n\n#{'='*15}\n#{new_values.inspect}\n#{'='*15}\n\n"
        core.update_attributes(new_values)
      end
    end
  end

  #  Helper method for `update_core`
  def compare_core_indexer(core_col, indexer_col)
    core_col == indexer_col ? "Same" : "Different"
  end

  def compare_acct_downcase_tester
    # One-Time Use
    cores = Core.where.not(alt_acct: nil)[0..1000]
    cores.each do |core|
      core_acct = core.sfdc_acct
      core_alt = core.alt_acct
      acct_match_sts = compare_acct_downcase(core_acct, core_alt)
      if core_acct != core_alt && acct_match_sts == "Same"
        puts "\n\n\ncore_acct: #{core_acct}"
        puts "core_alt: #{core_alt}"
        puts "acct_match_sts: #{acct_match_sts}\n\n\n"
      else
        puts "..."
      end
    end
  end

  def compare_acct_downcase(core_col, indexer_col)
    core_col_result = acct_squeezer(core_col)
    indexer_col_result = acct_squeezer(indexer_col)
    core_col_result == indexer_col_result ? "Same" : "Different"
  end


  #  Helper method for `update_core`
  def compare_score(core_score, new_score)
    core_score.to_i < new_score.to_i # true: okay to update, false: do not update
  end

  def acct_squeezer(org)
    squeezed_org = org.downcase
    squeezed_org = squeezed_org.gsub(/[^A-Za-z0-9]/, "")
    squeezed_org.strip!
    squeezed_org
  end


end
