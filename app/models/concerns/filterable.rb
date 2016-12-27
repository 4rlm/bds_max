module Filterable
    extend ActiveSupport::Concern

    module ClassMethods
        def filter(filtering_params)
            results = self.where(nil)
            filtering_params.each do |key, value|
                if value.present?
                    if !ActiveRecord::Base.connection.column_exists?(self.table_name, key)
                        ids = results.map(&:indexer_staff).select {|result| value["indexer_status"].include?(result.indexer_status) }.map(&:core_id)
                        results = results.where(id: ids)
                    else
                        results = results.public_send(key, value)
                    end
                end
            end
            results
        end
    end
end
