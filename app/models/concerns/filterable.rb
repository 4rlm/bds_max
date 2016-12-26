module Filterable
    extend ActiveSupport::Concern

    module ClassMethods
        def filter(filtering_params)
            results = self.where(nil)
            filtering_params.each do |key, value|
                if value.present?
                    if !ActiveRecord::Base.connection.column_exists?(self.table_name, key)
                        ids = self.select(:core_id).map(&:core_id).uniq
                        matches = Core.where("id" => ids, key => value).map(&:id)
                        results = results.where(core_id: matches)
                    else
                        results = results.public_send(key, value)
                    end
                end
            end
            results
        end
    end
end
