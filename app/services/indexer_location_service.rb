class IndexerLocationService
    def indexer_location_cleaner
        cores = Core.where.not(temporary_id: nil, location_link: nil)
        count = 0
        cores.each do |core|
            indexers = IndexerLocation.where(sfdc_id: core.temporary_id, link: core.location_link)
            indexers.each do |indexer|
                indexer.update_attributes(sfdc_id: core.sfdc_id, sfdc_acct: core.sfdc_acct)
            end
            puts "Done updating: #{count += 1}"
        end
    end
end
