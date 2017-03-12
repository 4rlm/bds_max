class DashboardService

    def mega_dash
        dash(Core)
        @dashboard_service.item_list(Core, [:bds_status, :staff_indexer_status, :location_indexer_status, :domain_status, :staffer_status, :geo_status, :who_status])
        puts "\n\n#{'-'*50}\n\n"
        dash(InHostPo)
        @dashboard_service.item_list(InHostPo, [:consolidated_term, :category])
        puts "\n\n#{'-'*50}\n\n"
        dash(Indexer)
        @dashboard_service.item_list(Indexer, [:redirect_status, :indexer_status, :who_status, :rt_sts, :cont_sts, :loc_status, :stf_status, :contact_status])
        puts "\n\n#{'-'*50}\n\n"
        dash(Location)
        @dashboard_service.item_list(Location, [:location_status, :sts_geo_crm, :sts_url, :sts_root, :sts_acct, :sts_addr, :sts_ph, :sts_duplicate, :url_sts, :acct_sts, :addr_sts, :ph_sts])
        puts "\n\n#{'-'*50}\n\n"
        dash(Staffer)
        @dashboard_service.item_list(Staffer, [:staffer_status, :cont_status])
        puts "\n\n#{'-'*50}\n\n"
        dash(Who)
        @dashboard_service.item_list(Who, [:who_status, :url_status])
    end

    def dash(model)
        cols = model.column_names
        cols.delete("id")
        cols.delete("created_at")
        cols.delete("updated_at")

        puts "#{'='*30} Total count #{'='*30}"
        cols.each do |col|
            num = model.all.map(&col.to_sym).count
            puts "#{col}: #{num}"
        end
        puts "#{'='*30} Unique count #{'='*30}"
        cols.each do |col|
            num = model.all.map(&col.to_sym).uniq.count
            puts "#{col}: #{num}"
        end
    end

    def item_list(model, attrs) # item_list(Staffer, [:staffer_status, :cont_status])
        list_hash = {}
        puts "#{'='*30} Item List #{'='*30}"
        attrs.each do |att|
            list_hash[att] = model.all.map(&att).uniq
            puts "#{att}: #{list_hash[att]}"
        end
        list_hash
    end

end # DashboardService class Ends ---
