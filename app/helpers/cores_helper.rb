module CoresHelper

    def column_list_core
      Core.column_names[1..-3].map {|col| [col, col] }
    end

    def status_list
        [['DF_Result', 'DF_Result'],
        ['Imported', 'Imported'],
        ['Matched', 'Matched'],
        ['No_Matches', 'No_Matches'],
        ['Isolate', 'Isolate'],
        ['Destroy', 'Destroy'],
        ['Junk', 'Junk']]
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
