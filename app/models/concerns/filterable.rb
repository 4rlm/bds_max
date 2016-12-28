module Filterable
    extend ActiveSupport::Concern

    module ClassMethods
        def filter(filtering_params)
            results = self.where(nil)
            filtering_params.each do |key, value|
                if value.present?
                    if !ActiveRecord::Base.connection.column_exists?(self.table_name, key)
                        status_key = value.keys.first
                        ids = results.map(&key.to_sym).select {|result| value[status_key].include?(result.send(status_key)) }.map(&:core_id)
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
