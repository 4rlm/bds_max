class IndexerStaffService
    def indexer_staff_cleaner
        cores = Core.where.not(temporary_id: nil, staff_link: nil)
        count = 0
        cores.each do |core|
            indexers = IndexerStaff.where(sfdc_id: core.temporary_id, link: core.staff_link)
            indexers.each do |indexer|
                indexer.update_attributes(sfdc_id: core.sfdc_id, sfdc_acct: core.sfdc_acct, sfdc_group_name: core.sfdc_group, sfdc_ult_acct: core.sfdc_ult_grp)
            end
            puts "Done updating: #{count += 1}"
        end
    end
end
