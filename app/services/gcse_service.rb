class GcseService
    def data_cleaner(gcse)
        create_pending_verification(gcse)
        puts "\n\n>>>>> Delete after created pending_verification: #{gcse.root}\n\n"
        gcse.destroy
    end

    def create_pending_verification(gcse)
        puts ">>> create_pending_verification"
        existance = check_core_if_exists?(gcse.root, gcse.domain) || check_solitary_if_exists?(gcse.root, gcse.domain) || check_exclude_root_if_exists?(gcse.root)
        inclusion = check_if_text_include_pos?(gcse.text) && check_if_text_include_del?(gcse.text)

        if !existance && inclusion
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

end
