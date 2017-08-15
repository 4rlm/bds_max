#### For example, see: /Users/Adam/Desktop/MaxDigital/bds_max/app/models/concerns/filterable.rb

module UrlRedirector
  extend ActiveSupport::Concern
  include InternetConnectionValidator #=> for validate_url(@raw_url)

  require 'curb'
  # IndexerService.new.url_redirect_starter

  ################ TRIAL BELOW #####################

  def start_curl
    puts "Starting curl ...."

    begin
      @result = Curl::Easy.perform(@raw_url) do |curl|
        puts "=== CURL CONNECTED ==="
        curl.follow_location = true
        curl.useragent = "curb"
        curl.connect_timeout = 10
        curl.enable_cookies = true
        # curl.ssl_verify_peer = false
      end
      curl_parser
    rescue
      if validate_url(@raw_url) #=> via InternetConnectionValidator
        puts "validating url....."
        start_curl
      else
        @result = nil
        @error_message = "Error: #{$!.message}"
        error_parser
      end
    end

  end

  def curl_parser
    curl_hash = url_formatter(@result.last_effective_url)
    @curl_url = curl_hash[:new_url]
    puts "@curl_url: #{@curl_url}"
  end

  def error_parser
    @indexer_status = "RD Error", @curl_url = nil
    if @error_message.include?("SSL connect error")
      @redirect_status = "SSL Error"
    elsif @error_message.include?("Couldn't resolve host name")
      @redirect_status = "Host Error"
    elsif @error_message.include?("Peer certificate")
      @redirect_status = "Certificate Error"
    elsif @error_message.include?("Failure when receiving data")
      @redirect_status = "Transfer Error"
    else
      @redirect_status = "Error"
    end
  end


  ######### ORIGINAL BELOW ############
  # def start_curl
  #   puts "Starting curl ...."
  #
  #   begin
  #     result = Curl::Easy.perform(@raw_url) do |curl|
  #       puts "=== CURL CONNECTED ==="
  #       curl.follow_location = true
  #       curl.useragent = "curb"
  #       curl.connect_timeout = 10
  #       curl.enable_cookies = true
  #       # curl.ssl_verify_peer = false
  #     end
  #
  #     crm_url_hash = url_formatter(result.last_effective_url)
  #     raw_url_final = crm_url_hash[:new_url]
  #
  #     if @raw_url != raw_url_final
  #       # indexer.update_attributes(redirect_status: "Updated", clean_url: raw_url_final)
  #     else
  #       # indexer.update_attributes(redirect_status: "Same", clean_url: raw_url_final)
  #     end
  #
  #   rescue  #begin rescue
  #     error_message = $!.message
  #     final_error_msg = "Error: #{error_message}"
  #     binding.pry
  #
  #     if final_error_msg && final_error_msg.include?("Error:")
  #       if final_error_msg.include?("SSL connect error")
  #         # indexer.update_attributes(indexer_status: "Redirect Error", redirect_status: "SSL Error")
  #       elsif final_error_msg.include?("Couldn't resolve host name")
  #         # indexer.update_attributes(indexer_status: "Redirect Error", redirect_status: "Host Error")
  #       elsif final_error_msg.include?("Peer certificate")
  #         # indexer.update_attributes(indexer_status: "Redirect Error", redirect_status: "Certificate Error")
  #       elsif final_error_msg.include?("Failure when receiving data")
  #         # indexer.update_attributes(indexer_status: "Redirect Error", redirect_status: "Transfer Error")
  #       else
  #         # indexer.update_attributes(indexer_status: "Redirect Error", redirect_status: "Error")
  #       end
  #     end
  #
  #   end  #end rescue
  #
  # end

  ###### Supporting Methods Below #######
  def url_formatter(url)
    unless url == nil || url == ""
      url.gsub!(/\P{ASCII}/, '')
      url = remove_slashes(url)
      if url.include?("\\")
        url_arr = url.split("\\")
        url = url_arr[0]
      end
      unless url.include?("www.")
        url = url.gsub!("//", "//www.")
      else
        url
      end

      uri = URI(url)
      new_url = "#{uri.scheme}://#{uri.host}"

      if uri.host
        host_parts = uri.host.split(".")
        new_root = host_parts[1]
      end
      return {new_url: new_url, new_root: new_root}
    end
  end


  def remove_slashes(url)
    # For rare cases w/ urls with mistaken double slash twice.
    parts = url.split('//')
    if parts.length > 2
      return parts[0..1].join
    end
    url
  end

end
