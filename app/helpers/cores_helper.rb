module CoresHelper
    def acct_merge_sts_indicator(core)
        sts = core.acct_merge_sts
        if sts == "Merge"
            html = <<-HTML
                <td class='bg-green'>#{fa_icon 'plus', class: 'fa-white'}</td>
            HTML
        elsif sts == "Flag"
            html = <<-HTML
                <td class='bg-orange'>#{fa_icon 'flag', class: 'fa-white'}</td>
            HTML
        elsif sts == "Drop"
            html = <<-HTML
                <td class='bg-red'>#{fa_icon 'minus', class: 'fa-white'}</td>
            HTML
        else
            html = <<-HTML
                <td><span></span></td>
            HTML
        end
        html.html_safe
    end
end
