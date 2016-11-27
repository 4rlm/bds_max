class CriteriaController < ApplicationController
    def all_criteria
        @all_exclude_root = ExcludeRoot.all
        @all_in_host_del =   InHostDel.all
        @all_in_host_neg =  InHostNeg.all
        @all_in_host_po =   InHostPo.all
        @all_in_suffix_del = InSuffixDel.all
        @all_in_text_del =   InTextDel.all
        @all_in_text_neg =  InTextNeg.all
        @all_in_text_po =    InTextPo.all
    end
end
