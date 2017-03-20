module CoresHelper


    def acct_merge_sts_indicator(core)
        sts = core.acct_merge_sts
        if sts == "Merge"
            html = <<-HTML
                <td class='bg-green geo w-xsm'>#{fa_icon 'plus', class: 'fa-white'}</td>
            HTML
        elsif sts == "Flag"
            html = <<-HTML
                <td class='bg-orange geo w-xsm'>#{fa_icon 'flag', class: 'fa-white'}</td>
            HTML
        elsif sts == "Drop"
            html = <<-HTML
                <td class='bg-red geo w-xsm'>#{fa_icon 'minus', class: 'fa-white'}</td>
            HTML
        else
            html = <<-HTML

            HTML
        end
        html.html_safe
    end
end
