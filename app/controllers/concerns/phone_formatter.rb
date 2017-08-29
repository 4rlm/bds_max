module PhoneFormatter
  extend ActiveSupport::Concern

  ## Call: IndexerService.new.phone_formatter_starter

  ## FORMATS PHONE AS: (000) 000-0000
  ## Assumes phone is legitimate, then formats.  Not designed to detect valid phone number.
  def phone_formatter(phone)
    regex = Regexp.new("[A-Z]+[a-z]+")
    if !phone.blank? && (phone != "N/A" || phone != "0") && !regex.match(phone)
      phone_stripped = phone.gsub(/[^0-9]/, "")
      (phone_stripped && phone_stripped[0] == "1") ? phone_step2 = phone_stripped[1..-1] : phone_step2 = phone_stripped

      final_phone = !(phone_step2 && phone_step2.length < 10) ? "(#{phone_step2[0..2]}) #{(phone_step2[3..5])}-#{(phone_step2[6..9])}" : phone
    else
      final_phone = nil
    end
    final_phone
  end

  ##########

  def model_phone_formatter(model, col) #=> Formats phone on model level.
    puts "#{"="*30}\n\n#{model.to_s}: model_phone_formatter\n\n"
    objs = model.where.not("#{col}": nil)
    # rts_manager = RtsManager.new

    objs.each do |obj|
      phone = obj.send(col)
      reg = Regexp.new("[(]?[0-9]{3}[ ]?[)-.]?[ ]?[0-9]{3}[ ]?[-. ][ ]?[0-9]{4}")
      if phone.first == "0" || phone.include?("(0") || !reg.match(phone)
        puts "\nINVALID Phone: #{phone.inspect} updated as nil\n#{"-"*30}"
        # obj.update_attribute(col, nil)
      else
        # new_phone = rts_manager.phone_formatter(phone)
        new_phone = phone_formatter(phone)

        if phone != new_phone
          puts "\nO Phone: #{phone.inspect}"
          puts "N Phone: #{new_phone.inspect}\n#{"-"*30}"
          # obj.update_attribute(col, new_phone)
        end
      end
    end
  end

  ##########

  def phones_arr_cleaner
    puts "#{"="*30}\n\nIndexer: phones_arr_cleaner\n\n"
    # rts_manager = RtsManager.new
    indexers = Indexer.where.not("phones = '{}'")

    indexers.each do |indexer|
      old_phones = indexer.phones
      new_phones = rts_manager.clean_phones_arr(old_phones)

      if old_phones != new_phones
        puts "#{"-"*30}\nOLD Phones: #{old_phones}"
        puts "NEW Phones: #{new_phones}"
        indexer.update_attribute(:phones, new_phones)
      end
    end
  end

end
