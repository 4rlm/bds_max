module GcsesHelper

    def column_list
      Gcse.column_names[1..-3].map {|col| [col, col] }
    end

    def status_list
        [['dropdown', 'dropdown'],
        ['block', 'block'],
        ['delete', 'delete'],
        ['imported', 'imported'],
        ['matched', 'matched'],
        ['unverified', 'unverified']]
    end

end
