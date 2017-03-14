module DashboardsHelper
    def grap_totals(model, col)
        dash = Dashboard.find_by(db_name: model, col_name: col)
        [dash.col_total, dash.item_list_total]
    end
end
