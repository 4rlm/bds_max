module CompareAndUpdate
  extend ActiveSupport::Concern
  ## Paste inside parent class: 'include CompareAndUpdate'

  ######## See Usage Notes at Bottom ########
  def start_compare_and_update
    setup_fields
    update_db
  end

  def compare_fields(target_field, compare_field)
    target_attr = @target_row.send(target_field)
    compare_attr = @compare_row.send(compare_field)

    if (target_attr == nil || @criteria.any? { |rule| target_attr.include?(rule) }) && compare_attr.present? && target_attr != compare_attr
      puts "\n#{target_field}: #{target_attr}"
      puts "#{compare_field}: #{compare_attr}"

      @update_hash[target_field.to_sym] = compare_attr
    end

  end

  def update_db
    if @update_hash.present?
      puts "@target_row.update_attributes(#{@update_hash})"
      # @target_row.update_attributes(@update_hash)
      binding.pry
    end

  end

end



######## See Usage Notes at Bottom ########
## For Usage Example, see: lib/servicers/geo_mega_migrator.rb
## Be sure to use below 2 methods inside the parent class.


# def setup_fields
#   @update_hash = {}
#   compare_fields("clean_url", "url")
#   compare_fields("acct_name", "geo_acct_name")
#   compare_fields("acct_pin", "geo_acct_pin")
#   setup_conditional_fields if compare_fields("full_addr", "geo_full_addr")
# end


# def setup_conditional_fields
#   ### Fields only compared if triggered by change in parent field.
#   compare_fields("street", "street")
#   compare_fields("city", "city")
#   compare_fields("state", "state_code")
#   compare_fields("zip", "postal_code")
# end
