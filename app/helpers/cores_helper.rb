module CoresHelper

    def column_list_core
      Core.column_names[1..-3].map {|col| [col, col] }
    end

    def core_status_list
        [['Dom Result', 'Dom Result'],
        ['Imported', 'Imported'],
        ['Matched', 'Matched'],
        ['No Matches', 'No Matches'],
        ['Isolate', 'Isolate'],
        ['Destroy', 'Destroy'],
        ['Junk', 'Junk'],
        ['Queue', 'Queue']]
    end

    def blank_remover(array)
        for i in 0...array.length
            if array[i] == ""
                array[i] = nil
            end
        end
        array.uniq
    end

    def formatted_date_list(datetime_arr)
        datetime_arr.map {|datetime| datetime.strftime("%m/%d/%Y") if datetime}.uniq
    end
end
