module DashboardsHelper
    def grap_totals(db_name, col)
        dash = Dashboard.find_by(db_name: db_name, col_name: col)
        [dash.col_total, dash.item_list_total]
    end
end
