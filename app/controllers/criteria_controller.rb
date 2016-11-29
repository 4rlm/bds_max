# class CriteriaController < ApplicationController
#     def all_criteria
#         @all_exclude_root = ExcludeRoot.order(term: :asc)
#         @all_in_host_del =   InHostDel.order(term: :asc)
#         @all_in_host_neg =  InHostNeg.order(term: :asc)
#         @all_in_host_po =   InHostPo.order(term: :asc)
#         @all_in_suffix_del = InSuffixDel.order(term: :asc)
#         @all_in_text_del =   InTextDel.order(term: :asc)
#         @all_in_text_neg =  InTextNeg.order(term: :asc)
#         @all_in_text_po =    InTextPo.order(term: :asc)
#     end
# end

class CriteriaController < ApplicationController
    def all_criteria
        @all_exclude_root = ExcludeRoot.order(term: :asc)
            respond_to do |format|
              format.html
              format.csv { render text: @all_exclude_root.to_csv }
        end

        @all_in_host_del =   InHostDel.order(term: :asc)

        @all_in_host_neg =  InHostNeg.order(term: :asc)

        @all_in_host_po =   InHostPo.order(term: :asc)

        @all_in_suffix_del = InSuffixDel.order(term: :asc)

        @all_in_text_del =   InTextDel.order(term: :asc)

        @all_in_text_neg =  InTextNeg.order(term: :asc)

        @all_in_text_po =    InTextPo.order(term: :asc)

    end
end
