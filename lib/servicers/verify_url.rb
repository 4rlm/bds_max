# Bridges UrlRedirector Module to indexer/services.
require 'delayed_job'

class VerifyUrl
  include UrlRedirector #=> concerns/url_redirector.rb
  # Call: IndexerService.new.start_url_redirect
  # Call: VerifyUrl.new.starter

  def starter
    begin
      queried_ids = Indexer.select(:id).where.not(indexer_status: "Archived").where(url_redirect_date: nil).sort[0...200].pluck(:id)

      @last_id = queried_ids.last
      nested_ids = queried_ids.in_groups(4)
      nested_ids.each { |ids| delay.nested_iterator(ids) }
    rescue
      p "\n\n==== Empty Query ====\n\n"
    end
  end

  def nested_iterator(ids)
    ids.each { |id| delay.activate_curl(id) }
  end

  def activate_curl(id)
    @indexer = Indexer.where(id: id).select(:id, :raw_url, :clean_url, :indexer_status, :redirect_status).first
    @raw_url = @indexer.clean_url #=> Verifying clean_url still valid. (vs running raw_url)
    @indexer_status = @indexer.indexer_status
    @redirect_status = @indexer.redirect_status
    start_curl
    db_updater(id)
  end

  def get_curl_response
    @indexer_status = "RD Result"
    if @raw_url != @curl_url
      @redirect_status = "Updated"
    else
      @redirect_status = "Same"
    end
  end

  def db_updater(id)
    puts "DB raw_url: #{@raw_url}"
    get_curl_response if @curl_url
    # puts "NEW curl_url: #{@curl_url}"
    puts "NEW indexer_status: #{@indexer_status}"
    puts "NEW redirect_status: #{@redirect_status}"
    puts "#{"="*30}\n\n"

    @indexer.update_attributes(url_redirect_date: DateTime.now, indexer_status: @indexer_status, redirect_status: @redirect_status, clean_url: @curl_url)

    # @indexer = Indexer.where(id: id).select(:id, :raw_url, :clean_url, :indexer_status, :redirect_status).first
    # puts @indexer.inspect

    if id == @last_id
      puts "\n\n===== Last ID: #{id}===== \n\n"
      starter
    end
  end


end



##### ORIGINAL #####
# class VerifyUrl
#   include UrlRedirector #=> concerns/url_redirector.rb
#   # Call: IndexerService.new.start_url_redirect
#   # Call: VerifyUrl.new.starter
#
#   def starter
#     query_regulator
#   end
#
#   def query_generator
#     begin
#       queried_ids = Indexer.select(:id).where.not(indexer_status: "Archived").where(url_redirect_date: nil).sort[0...20].pluck(:id)
#     rescue
#       queried_ids = []
#     end
#   end
#
#   def query_regulator
#     @continue = true
#
#     if @continue
#       queried_ids = query_generator
#
#       if queried_ids.present?
#         puts "\n\n=== queried_ids ===\n#{queried_ids}\n\n"
#         @last_id = queried_ids.last
#         nested_ids = queried_ids.in_groups(4)
#         query_iterator(nested_ids)
#       else
#         @continue = false
#         puts "\n\n=== Query: VerifyUrl ===\nCompleted or Empty\n(continue = false)\n\n"
#       end
#     end
#   end
#
#   def query_iterator(nested_ids)
#     nested_ids.each do |ids|
#       nested_iterator(ids)
#     end
#   end
#
#   def nested_iterator(ids)
#     ids.each do |id|
#       activate_curl(id)
#     end
#   end
#
#   def activate_curl(id)
#     puts "\n\n ==== Testing >>> Inside [activate_curl]!!! ====\n\n"
#     @indexer = Indexer.where(id: id).select(:id, :raw_url, :clean_url, :indexer_status, :redirect_status).first
#     @raw_url = @indexer.clean_url #=> Verifying clean_url still valid. (vs running raw_url)
#     @indexer_status = @indexer.indexer_status
#     @redirect_status = @indexer.redirect_status
#     start_curl
#     db_updater(id)
#   end
#
#   def get_curl_response
#     @indexer_status = "RD Result"
#     if @raw_url != @curl_url
#       @redirect_status = "Updated"
#     else
#       @redirect_status = "Same"
#     end
#   end
#
#   def db_updater(id)
#     puts "DB raw_url: #{@raw_url}"
#     get_curl_response if @curl_url
#     # puts "NEW curl_url: #{@curl_url}"
#     puts "NEW indexer_status: #{@indexer_status}"
#     puts "NEW redirect_status: #{@redirect_status}"
#     puts "#{"="*30}\n\n"
#
#     @indexer.update_attributes(url_redirect_date: DateTime.now, indexer_status: @indexer_status, redirect_status: @redirect_status, clean_url: @curl_url)
#
#     @indexer = Indexer.where(id: id).select(:id, :raw_url, :clean_url, :indexer_status, :redirect_status).first
#     puts @indexer.inspect
#
#     if id == @last_id
#       puts "\n\n===== Last ID: #{id}===== \n\n"
#       query_regulator
#     end
#   end
#
#
# end