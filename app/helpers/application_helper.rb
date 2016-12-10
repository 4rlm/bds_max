module ApplicationHelper
    def ordered_list(arr)
        arr.uniq!
        if arr.include?(nil)
            arr.delete(nil)
            arr.sort
        else
            arr.sort
        end
    end
end
