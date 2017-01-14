class GcseService
    def data_cleaner(gcse)
        create_pending_verification(gcse)
        puts "\n\n>>>>> Delete after created pending_verification: #{gcse.root}\n\n"
        gcse.destroy
    end

    def create_pending_verification(gcse)
        existance = check_core_if_exists?(gcse.root, gcse.domain) || check_solitary_if_exists?(gcse.root, gcse.domain) || check_exclude_root_if_exists?(gcse.root)
        inclusion = check_if_text_include_pos?(gcse.text) && check_if_text_include_del?(gcse.text)

        if !existance && inclusion
            puts "\n\n>>>>> Create PendingVerification: #{gcse.root}\n\n"
            PendingVerification.find_or_create_by(root: gcse.root, domain: gcse.domain)
        end
    end

    def check_core_if_exists?(root, domain)
        cores = Core.all
        root_bool = cores.map(&:sfdc_root).include?(root) || cores.map(&:matched_root).include?(root)
        url_bool = cores.map(&:sfdc_url).include?(domain) || cores.map(&:matched_url).include?(domain)

        if root_bool && url_bool
            return true
        end
        false
    end

    def check_solitary_if_exists?(root, domain)
        result_arr = Solitary.where(solitary_root: root, solitary_url: domain)
        return result_arr.any? ? true : false
    end

    def check_exclude_root_if_exists?(root)
        result_arr = ExcludeRoot.where(term: root)
        return result_arr.any? ? true : false
    end

    def check_if_text_include_pos?(text)
        InTextPo.all.each do |po|
            if text.include?(po.term)
                return true
            end
        end
        false
    end

    def check_if_text_include_del?(text)
        InTextDel.all.each do |del|
            if text.include?(del.term)
                return false
            end
        end
        true
    end

    def auto_root_acct_match(gcse)
        ori = gcse.sfdc_acct
        acct = gcse.sfdc_acct
        return true if gcse.root == acct

        afters = [",", " - ", "("]
        for a in afters
            if acct.include?(a)
                index = acct.index(a)
                acct = acct[0...index]
            end
        end

        parts = acct.downcase.split
        drops = [",", ".", "co", "llc", "inc", "&", ":", "-", "'", "/", "ltd"]
        for d in drops
            parts.delete(d) if parts.include?(d)
        end

        modified = parts.map(&:strip).join
        result = gcse.root == modified

        puts "\n\n>>>>> MODIFIED: #{ori} VS #{modified}\n\n" if result
        return result
    end

    # This cleans the existing Gcse table.
    def gcse_cleaner_btn
        sfdc_ids = Gcse.all.map(&:sfdc_id)
        matched_urls = Core.all.map(&:matched_url)
        exclude_roots = ExcludeRoot.all.map(&:term)

        sfdc_ids.each do |sfdc_id|
            gcses = Gcse.where(sfdc_id: sfdc_id)
            domains = []

            gcses.each do |gcse|
                # (Case 1) Deletes the duplicate domains
                if domains.include?(gcse.domain)
                    puts ">>>> gcse_cleaner (1) | sfdc_id: #{gcse.sfdc_id}, domain: #{gcse.domain}"
                    gcse.destroy
                # (Case 2) Deletes gcse that has matched_url and exclude_root
                elsif matched_urls.include?(gcse.domain) || exclude_roots.include?(gcse.root)
                    puts ">>>> gcse_cleaner (2) | sfdc_id: #{gcse.sfdc_id}, domain: #{gcse.domain}"
                    gcse.destroy
                else # Collects the unique domain
                    domains << gcse.domain
                    puts ">>>> Collects unique domain in #{domains}."
                end
            end
        end
    end

    # Moved methods from controller
    def matchify_rows(gcses)
        sfdc_id_source = gcses.map(&:sfdc_id) #[2341234, 1234134]
        domain_source = gcses.map(&:domain) #["http://www.some.com", "http://www.any.com"]
        sfdc_url_source = gcses.map(&:sfdc_url_o)
        root_source = gcses.map(&:root) #["some", "any"]
        sfdc_root_source = gcses.map(&:sfdc_root)

        # 1) Compare
        url_results = Gcse.compare(domain_source, sfdc_url_source)
        root_results = Gcse.compare(root_source, sfdc_root_source)

        # 2) Add Matched gcses to Core
        # Updates bds_status, matched_url, and matched_root in Core Table.
        for i in 0...sfdc_id_source.length
            id = sfdc_id_source[i]
            root = root_source[i]

            data = Core.find_by(sfdc_id: id)
            data.update_attributes(bds_status: "Matched", matched_url: domain_source[i], sfdc_root: sfdc_root_source[i], matched_root: root, url_comparison: url_results[i], root_comparison: root_results[i], staff_indexer_status: "Ready", location_indexer_status: "Ready", inventory_indexer_status: "Ready")

            # When 'data' in Core is updated to "Matched", check if its url exists in Solitary.
            # If so, delete the matched url in Solitary.
            SolitaryService.new.check_solitary_for_matched(data.matched_url)

            # 3) Solitary table, Pending table, destroy_all
            left_overs(id, root)
        end
    end

    def no_matchify_rows(ids)
        rows = Gcse.where(id: ids)
        sfdc_id_source = rows.map(&:sfdc_id) #[2341234, 1234134]
        valid_suffixes = [".com", ".net"]

        for id in sfdc_id_source
            # 1) Add Matched rows to Core: Updates bds_status.
            core = Core.find_by(sfdc_id: id)
            core.update_attributes(bds_status: "No Matches")

            # 2) Solitary table, Pending status
            gcses = Gcse.where(sfdc_id: id)
            for gcse in gcses
                # 2-A) CASE: Positive Host root && valid suffix
                if Gcse.solitarible?(gcse.root) && valid_suffixes.include?(gcse.suffix)
                    # Create a Solitary row if not exists. Then destroy the current gcse row.
                    create_solitary(gcse)
                    puts "\n\n>>>>> Sent to solitary checker: #{gcse.root} \n\n"
                    tmp_id = gcse.id # just for testing
                    gcse.destroy
                    puts "============> #{Gcse.find_by(id: tmp_id)}"
                else # 2-B) !(Positive Host root && valid suffix)
                    # Create with root and url in pending verification table if not already included in Core, PendingVerification, Solitary, ExcludeRoot
                    create_pending_verification(gcse)
                    puts "\n\n>>>>> Sent to pending_verification checker: #{gcse.root}\n\n"
                    tmp_id = gcse.id # just for testing
                    gcse.destroy
                    puts "============> #{Gcse.find_by(id: tmp_id)}"
                end
            end
        end
    end

    def left_overs(id, root)
        gcses = Gcse.where(sfdc_id: id)
        valid_suffixes = [".com", ".net"]

        for gcse in gcses.where.not(root: root)
            # 3-A) CASE: (sfdc_id && !root) && (Positive Host root && valid suffix)
            if Gcse.solitarible?(gcse.root) && valid_suffixes.include?(gcse.suffix)
                # Create a Solitary row if not exists. Then destroy the current gcse row.
                create_solitary(gcse)
                puts "\n\n>>>>> Sent to solitary checker: #{gcse.root} \n\n"
                gcse.destroy
            else # 3-B) CASE: (sfdc_id && !root) && !(Positive Host root && valid suffix)
                # Create with root and url in pending verification table if not already included in Core, PendingVerification, Solitary, ExcludeRoot
                create_pending_verification(gcse)
                puts "\n\n>>>>> Sent to pending_verification checker: #{gcse.root}\n\n"
                gcse.destroy
            end
        end

        # 3-C) CASE: sfdc_id && root
        # Delete Gcse rows which sfdc_id and root are the same as the matched row's.
        puts "\n\n>>>>> Delete Bunch: #{gcses.where(root: root).map(&:root).join(", ")}\n\n"
        gcses.where(root: root).destroy_all
    end

    def create_solitary(gcse)
        existance = check_core_if_exists?(gcse.root, gcse.domain) || check_exclude_root_if_exists?(gcse.root)
        if !existance
            puts "\n\n>>>>> Sent to Solitary: #{gcse.root}\n\n"
            Solitary.find_or_create_by(solitary_root: gcse.root, solitary_url: gcse.domain)
        end
    end

end
