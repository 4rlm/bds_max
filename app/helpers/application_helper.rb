module ApplicationHelper
    def ordered_list(arr)
        arr.uniq!.delete(nil)
        arr.sort
    end
end
