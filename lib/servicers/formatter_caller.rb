# require 'mechanize'
# require 'nokogiri'
# require 'open-uri'
# require 'delayed_job'
# require 'curb'

class FormatterCaller
  include PhoneFormatter
  ## FormatterCaller class runs formatting methods in PhoneFormatter module.  Is intended to be used before running the dashboard finalizers as a final check on proper formatting.

  # Call: IndexerService.new.model_phone_formatter_starter
  # Call: FormatterCaller.new.model_phone_formatter_caller
  def model_phone_formatter_caller
    ## Checks all phones in entire db to ensure proper formatting, before running finalizers.
    model_phone_formatter(Core, :sfdc_ph)
    model_phone_formatter(Core, :alt_ph)
    model_phone_formatter(Indexer, :phone)
    model_phone_formatter(Location, :phone)
    model_phone_formatter(Location, :crm_phone)
    model_phone_formatter(Staffer, :phone)
    model_phone_formatter(Who, :registrant_phone)
    phones_arr_cleaner # Clean Indexer's phones
  end

end
