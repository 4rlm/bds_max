module GcsesHelper

    def column_list
      Gcse.column_names[1..-3].map {|col| [col, col] }
    end

    def status_list
        [['Dom Result', 'Dom Result'],
        ['Imported', 'Imported'],
        ['Auto-Match', 'Auto-Match'],
        ['No Auto-Matches', 'No Auto-Matches'],
        ['Matched', 'Matched'],
        ['No Matches', 'No Matches'],
        ['Pending Verification', 'Pending Verification'],
        ['Solitary', 'Solitary'],
        ['Junk', 'Junk'],
        ['Destroy', 'Destroy']]
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
