class DashboardService

    def mega_dash
        dash(Core)
        list_getter(Core, [:alt_source, :bds_status, :staff_pf_sts, :loc_pf_sts, :staffer_sts, :sfdc_type, :sfdc_tier, :sfdc_sales_person, :sfdc_state, :sfdc_franch_cons, :sfdc_franch_cat, :template, :staffer_sts, :acct_merge_sts])
        puts "\n\n#{'-'*50}\n\n"
        dash(InHostPo)
        list_getter(InHostPo, [:consolidated_term, :category])
        puts "\n\n#{'-'*50}\n\n"
        dash(Indexer)
        list_getter(Indexer, [:redirect_status, :indexer_status, :who_status, :rt_sts, :cont_sts, :loc_status, :stf_status, :contact_status, :template, :geo_status])
        puts "\n\n#{'-'*50}\n\n"
        dash(Location)
        list_getter(Location, [:location_status, :sts_geo_crm, :sts_url, :sts_acct, :sts_addr, :sts_ph, :sts_duplicate, :url_sts, :acct_sts, :addr_sts, :ph_sts, :source])
        puts "\n\n#{'-'*50}\n\n"
        dash(Staffer)
        list_getter(Staffer, [:staffer_status, :cont_source, :sfdc_type, :sfdc_tier, :sfdc_sales_person, :cont_status, :job])
        puts "\n\n#{'-'*50}\n\n"
        dash(Who)
        list_getter(Who, [:who_status, :url_status])
    end

    def dash(model)
        cols = model.column_names
        cols.delete("created_at")
        cols.delete("updated_at")

        puts "#{'='*30} #{model.to_s} #{'='*30}"
        cols.each do |col|
            records = model.all.map(&col.to_sym)
            records.delete_if {|el| el.blank?}
            total = records.count
            uniqs = records.uniq.count
            dash = Dashboard.find_by(db_name: model.to_s, col_name: col)

            puts "[#{col}] total: #{total}, uniqs: #{uniqs}"
            dash.update_attributes(col_total: total, item_list_total: uniqs) if dash
        end
    end

    def list_getter(model, cols) # list_getter(Staffer, [:staffer_sts, :cont_status])
        puts "#{'='*30} Item List #{'='*30}"
        cols.each do |col|
            list = model.all.map(&col).uniq
            dash = Dashboard.find_by(db_name: model.to_s, col_name: col)
            puts "#{col}: #{list.inspect}"
            dash.update_attributes(item_list: list) if dash
        end
    end

    def render_summarize_data(db_name, cols)
        result = [
            {
                name: "col_total",
                data: []
            },{
                name: "item_list_total",
                data: []
            }
        ]

        cols.each do |col|
            dash = Dashboard.find_by(db_name: db_name, col_name: col)
            if dash
                result[0][:data] << [col, dash.col_total]
                result[1][:data] << [col, dash.item_list_total]
            end
        end

        result # return: an array
    end

end # DashboardService class Ends ---
