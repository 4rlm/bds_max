require 'open-uri'
require 'mechanize'
require 'uri'
require 'nokogiri'
require 'socket'
require 'httparty'
require 'delayed_job'
require 'indexer_helper/rts/dealerfire_rts'
require 'indexer_helper/rts/cobalt_rts'
require 'indexer_helper/rts/dealer_inspire_rts'
require 'indexer_helper/rts/dealeron_rts'
require 'indexer_helper/rts/dealer_com_rts'
require 'indexer_helper/rts/dealer_direct_rts'
require 'indexer_helper/rts/dealer_eprocess_rts'
require 'indexer_helper/rts/dealercar_search_rts'
# require 'indexer_helper/page_finder_original'  # ### CAN REMOVE THIS.  HAS BEEN REPLACED.
require 'indexer_helper/rts/rts_helper'
require 'indexer_helper/rts/rts_manager'
require 'indexer_helper/unknown_template' # Unknown template's info scraper
require 'indexer_helper/helper' # All helper methods for indexer_service
require 'servicers/url_verifier' # Bridges UrlRedirector Module to indexer/services.
require 'curb' #=> for url_redirector

# Call: IndexerService.new.start_page_finder
# Call: PageFinder.new.pf_starter

class PageFinder
  include InternetConnectionValidator
  include ComplexQueryIterator

  def initialize
    puts "\n\n== Welcome to the PageFinder Class! ==\n\n"
    @class_pid = Process.pid
    @query_limit = 20 #=> Number of rows per batch in raw_query.

    ## Below are Settings for ComplexQueryIterator Module.
    @dj_wait_time = 3 #=> How often to check dj queue count.
    @dj_count_limit = 0 #=> Num allowed before releasing next batch.
    @number_of_groups = 2 #=> Divide query into groups of x.
  end

  def pf_starter
    generate_query
  end

  def generate_query
    # Indexer.select(:id).where.not("redirect_status LIKE '%Error%'").where(archive: false).where.not(clean_url: nil).where(page_finder_date: nil).where.not(template: nil).where("template NOT LIKE '%Error%'").count

    raw_query = Indexer
    .select(:id)
    .where.not("redirect_status LIKE '%Error%'")
    .where(archive: false)
    .where.not(clean_url: nil)
    .where(page_finder_date: nil)
    .where.not(template: nil)
    .where("template NOT LIKE '%Error%'")

    iterate_raw_query(raw_query) #=> Method is in ComplexQueryIterator.
  end

  #############################################
  ## ComplexQueryIterator takes raw_query and creates series of forked iterations based on limits established above in initialize method.  Then it calls 'template_starter(id)' method.  Module serves as bridge for iteration work.
  #############################################

  def view_indexer_current_db_info
    puts "\n=== Current DB Info ===\n"
    puts "indexer_status: #{@indexer.indexer_status}"
    puts "template: #{@indexer.template}"
    puts "clean_url: #{@url}"
    # puts "page_finder_date: #{@indexer.page_finder_date}"
    puts "#{"="*30}\n\n"
  end

  ##########################

  def template_starter(id)
    @indexer = Indexer.find(id)
    # view_indexer_current_db_info(

    #### !!!! RAW URL BEING USED FOR TESTING ONLY. ###
    @url = @indexer.clean_url #=> !CHANGE BACK TO THIS, AFTER TESTING!!
    # url = @indexer.raw_url #=> !FOR TESTING ONLY!!
    puts "\n\nURL: #{@url}"
    start_mechanize(@url) #=> returns @html

    if @html
      page = @html
      page_finder(page, "staff")
      page_finder(page, "location")
    else
      puts "\n\n== Page Finder Error!! ==\n\n"
      puts @error_code
      @indexer.update_attributes(indexer_status: "PageFinder", loc_status: @error_code, stf_status: @error_code, page_finder_date: DateTime.now)
    end
  end

  ################################################

  def page_finder(page, mode)
    list = text_href_list(mode)
    text_list = list[:text_list]
    for text in text_list
      pages = page.links.select {|link| link.text.downcase.include?(text.downcase)}
      if pages.any?
        url_split_joiner(pages.first, mode)
        break
      end
    end

    if pages.empty? || pages.nil?
      href_list = list[:href_list]
      href_list.delete(/MeetOurDepartments/) # /MeetOurDepartments/ is the last href to search.
      for href in href_list
        if pages = page.link_with(:href => href)
          url_split_joiner(pages, mode)
          break
        end
      end
      if !pages
        # if pages = page.link_with(:href => /MeetOurDepartments/)
        #     url_split_joiner(pages, mode)
        add_indexer_row_with("PF None", "PF None", nil, nil, mode)
        # end
      end
    end
  end

  def url_split_joiner(pages, mode)
    url_s = @url.split('/')
    url_http = url_s[0]
    url_www = url_s[2]
    joined_url = validater(url_http, '//', url_www, pages.href)
    add_indexer_row_with("PF Result", pages.text.strip, pages.href, joined_url, mode)
  end

  def add_indexer_row_with(status, text, href, link, mode)
    # Clean the Data before updating database
    clean = record_cleaner(text, href, link)
    text, href, link = clean[:text], clean[:href], clean[:link]

    if mode == "location"
      printer(mode, status, text, link)
      @indexer.update_attributes(indexer_status: "PageFinder", loc_status: status, location_url: link, location_text: text, page_finder_date: DateTime.now) if @indexer != nil
    elsif mode == "staff"
      printer(mode, status, text, link)
      @indexer.update_attributes(indexer_status: "PageFinder", stf_status: status, staff_url: link, staff_text: text, page_finder_date: DateTime.now) if @indexer != nil
    end
  end

  def validater(url_http, dbl_slash, url_www, dirty_url)
    if dirty_url[0] != "/"
      dirty_url = "/" + dirty_url
    end

    if dirty_url.include?(url_http + dbl_slash)
      dirty_url
    else
      url_http + dbl_slash + url_www + dirty_url
    end
  end

  def to_regexp(arr)
    arr.map {|str| Regexp.new(str)}
  end

  def text_href_list(mode)
    # if mode == "staff"
    #   text, href, term = "staff_text", "staff_href", @indexer.template
    # elsif mode == "location"
    #   text, href, term = "loc_text", "loc_href", "general"
    # end

    if mode == "staff"
      text = "staff_text"
      href = "staff_href"
      term = @indexer.template
      special_templates = ["Cobalt", "Dealer Inspire", "DealerFire"]
      if not special_templates.include?(term)
        term = 'general'
      end
    elsif mode == "location"
      text = "loc_text"
      href = "loc_href"
      term = "general"
    end

    text_list = IndexerTerm.where(sub_category: text).where(criteria_term: term).map(&:response_term)
    href_list = to_regexp(IndexerTerm.where(sub_category: href).where(criteria_term: term).map(&:response_term))
    return {text_list: text_list, href_list: href_list}

    # list = text_href_list(mode)
    # text_list = list[:text_list]

  end

  # ================== Helper ==================
  # Clean the Data before updating database
  def record_cleaner(text, href, link)
    # puts "\n\n==================================\n#{"="*15} DIRTY DATA #{"="*15}\ntext: #{text.inspect}\nhref: #{href.inspect}\nlink: #{link.inspect}\n#{"-"*40}\n\n"
    link = link_deslasher(link)
    {text: text, href: href, link: link}
  end

  def link_deslasher(link)
    link = (link && link[0] == "/") ? link[1..-1] : link
    link = (link && link[-1] == "/") ? link[0...-1] : link
  end

  def printer(mode, status, text, link)
    puts "\n\n==================================\n\nmode: #{mode.inspect}\n#{status.inspect}: #{text.inspect}\nlink: #{link.inspect}\ntext: #{text.inspect}\n#{"-"*40}\n\n"
  end

end
