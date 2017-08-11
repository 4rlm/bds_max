#### For example, see: /Users/Adam/Desktop/MaxDigital/bds_max/app/models/concerns/filterable.rb

module InternetConnectionValidator
  extend ActiveSupport::Concern

  def start_mechanize(url_string)
    # url_string = "http://www.teamhondaon30.com/meet-our-staff"
    puts "Starting mechanize ...."

    begin
      @agent = Mechanize.new
      @html = @agent.get(url_string)
      puts "=== GOOD URL ===\nURL: #{url}"
    rescue
      if validate_url(url_string)
        puts "validating url....."
        start_mechanize(url_string)
      else
        @html = nil
        @html_error = $!.message
      end
    end
  end

  def ping_url
    pingable_urls = %w(
    http://speedtest.hafslundtelekom.net/
    http://www.whatsmyip.org/
    https://fast.com/
    http://speedtest.xfinity.com/
    https://www.iplocation.net/
    https://www.wikipedia.org/
    http://www.bandwidthplace.com/
    http://www.speedinternet.co/
    https://www.google.com/)
    pingable_urls.sample
  end

  def test_internet_connection
    sample_url = ping_url
    begin
      result = true if open(ping_url)
    rescue
      result = false
    end

    puts "Internet Connection: #{result} via #{sample_url} ==="
    result
  end

  def url_exist?(url_string)
    begin
      url = URI.parse(url_string)
      req = Net::HTTP.new(url.host, url.port)
      req.use_ssl = (url.scheme == 'https')
      res = req.request_head(url || '/')
      if res.kind_of?(Net::HTTPRedirection)
        url_exist?(res['location']) # Go after any redirect and make sure you can access the redirected URL
      else
        res.code[0] != "4" #false if http code starts with 4 - error on your side.
      end
    rescue
      # puts $!.message
      false #false if can't find the server
    end
  end


  def validate_url(url_string)
    if url_exist?(url_string)
      puts "=== GOOD URL ===\nURL: #{url_string}"
    else
      if not test_internet_connection
        connection = false
        ping_attempt_count = 1

        while !connection
          sleep_time = 5 * ping_attempt_count
          puts "\nNO INTERNET CONNECTION\nCONNECTION TEST ATTEMPTS: #{ping_attempt_count}\nTRY AGAIN IN: #{sleep_time} SECONDS\n#{"="*30}\n\n"
          sleep(sleep_time)
          connection = test_internet_connection
          ping_attempt_count += 1
          break if connection
        end
        validate_url(url_string)
      end
    end
    # sleep(0.015)
  end

end