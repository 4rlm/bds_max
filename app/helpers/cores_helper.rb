module CoresHelper

    def column_list
      Core.column_names[1..-3].map {|col| [col, col] }
    end

    def status_list
        [['dropdown', 'dropdown'],
        ['block', 'block'],
        ['delete', 'delete'],
        ['imported', 'imported'],
        ['matched', 'matched'],
        ['unverified', 'unverified']]
    end

    def blank_remover(array)
        for i in 0...array.length
            if array[i] == ""
                array[i] = nil
            end
        end
        array.uniq
    end
end
