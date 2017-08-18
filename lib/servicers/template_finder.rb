# Bridges UrlRedirector Module to indexer/services.
require 'delayed_job'

class TemplateFinder
  include UrlRedirector #=> concerns/url_redirector.rb
  # Call: IndexerService.new.start_url_redirect
  # Call: VerifyUrl.new.starter

  def starter
    begin
      queried_ids = Indexer.select(:id).where.not(indexer_status: "Archived").where.not(indexer_status: "RD Error")

      @last_id = queried_ids.last
      nested_ids = queried_ids.in_groups(4)
      nested_ids.each { |ids| delay.nested_iterator(ids) }
    rescue
      p "\n\n==== Empty Query ====\n\n"
    end
  end

  def nested_iterator(ids)
    ids.each { |id| delay.template_starter(id) }
  end

  def template_starter(id)
    indexer = Indexer.find(id)
    # criteria_term = nil
    # template = nil

    url = indexer.clean_url
    start_mechanize(url) #=> returns @html
    html = @html

    begin
      db_template = indexer.template

      indexer_terms = IndexerTerm.where(category: "template_finder").where(sub_category: "at_css")

      indexer_terms.each do |indexer_term|
        criteria_term = indexer_term.criteria_term
        if html.at_css('html').text.include?(criteria_term)
          template = indexer_term.response_term
          # indexer.update_attribute(:template, template) if template
        else
          template = "Unidentified"
          # indexer.update_attribute(:template, "Unidentified")
        end
      end

    rescue
      ## MOVING THESE ERROR TERMS TO THE INTERNET CONNECTION VALIDATOR. ##
      error_msg = "CS Error: #{@html_error}"
      if error_msg.include?("404 => Net::HTTPNotFound")
        cs_error_code = "404 Error"
      elsif error_msg.include?("connection refused")
        cs_error_code = "Connection Error"
      elsif error_msg.include?("undefined method")
        cs_error_code = "Method Error"
      elsif error_msg.include?("TCP connection")
        cs_error_code = "TCP Error"
      else
        cs_error_code = "CS Error"
      end

      template = cs_error_code
    end

    puts "\n\n== template: '#{template}' ==\n\n"

    indexer.update_attributes(template_date: DateTime.now, indexer_status: "TemplateFinder", template: template)

    if id == @last_id
      puts "\n\n===== Last ID: #{id}===== \n\n"
      starter
    end

  end

  # def activate_curl(id)
  #   @indexer = Indexer.where(id: id).select(:id, :raw_url, :clean_url, :indexer_status, :redirect_status).first
  #   @raw_url = @indexer.clean_url #=> Verifying clean_url still valid. (vs running raw_url)
  #   @indexer_status = @indexer.indexer_status
  #   @redirect_status = @indexer.redirect_status
  #   start_curl
  #   db_updater(id)
  # end


  # def get_curl_response
  #   @indexer_status = "RD Result"
  #   if @raw_url != @curl_url
  #     @redirect_status = "Updated"
  #   else
  #     @redirect_status = "Same"
  #   end
  # end


  # def db_updater(id)
  #   puts "DB raw_url: #{@raw_url}"
  #   get_curl_response if @curl_url
  #   # puts "NEW curl_url: #{@curl_url}"
  #   puts "NEW indexer_status: #{@indexer_status}"
  #   puts "NEW redirect_status: #{@redirect_status}"
  #   puts "#{"="*30}\n\n"
  #
  #   @indexer.update_attributes(url_redirect_date: DateTime.now, indexer_status: @indexer_status, redirect_status: @redirect_status, clean_url: @curl_url)
  #
  #   # @indexer = Indexer.where(id: id).select(:id, :raw_url, :clean_url, :indexer_status, :redirect_status).first
  #   # puts @indexer.inspect
  #
  #   if id == @last_id
  #     puts "\n\n===== Last ID: #{id}===== \n\n"
  #     starter
  #   end
  # end


end
