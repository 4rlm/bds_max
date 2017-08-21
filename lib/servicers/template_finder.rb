# Bridges UrlRedirector Module to indexer/services.
require 'delayed_job'

# Call: IndexerService.new.start_template_finder
# Call: TemplateFinder.new.tf_starter

class TemplateFinder
  include InternetConnectionValidator
  include ComplexQueryIterator

  def initialize
    puts "\n\n== Welcome to the TemplateFinder Class! ==\n\n"
    @query_limit = 10 #=> Number of rows per batch in raw_query.

    ## Below are Settings for ComplexQueryIterator Module.
    @dj_wait_time = 3 #=> How often to check dj queue count.
    @dj_count_limit = 0 #=> Num allowed before releasing next batch.
    @number_of_groups = 2 #=> Divide query into groups of x.
  end

  def tf_starter
    generate_query
  end

  def generate_query
    # queried_ids = Indexer
    # .select(:id)
    # .where("indexer_status != 'Archived'", template_date: nil)
    # .where("redirect_status NOT LIKE '%Error%'")
    # .sort[0...200].pluck(:id)

    raw_query = Indexer
    .select(:id)
    .where("indexer_status != 'Archived'", template_date: nil)
    .where("redirect_status NOT LIKE '%Error%'")

    iterate_raw_query(raw_query) #=> Method is in ComplexQueryIterator.
  end

  #############################################
  ## ComplexQueryIterator takes raw_query and creates series of forked iterations based on limits established above in initialize method.  Then it calls 'template_starter(id)' method.  Module serves as bridge for iteration work.
  #############################################

  def template_starter(id)
    @indexer = Indexer.where(id: id).select(:id, :indexer_status, :clean_url, :template, :template_date, :template_status).first

    # criteria_term = nil
    # template = nil

    @url = @indexer.clean_url
    start_mechanize(@url) #=> returns @html
    html = @html

    begin
      indexer_terms = IndexerTerm.where(category: "template_finder").where(sub_category: "at_css")

      indexer_terms.each do |indexer_term|
        criteria_term = indexer_term.criteria_term
        if html.at_css('html').text.include?(criteria_term)
          @new_template = indexer_term.response_term
          db_updater(id)
        else
          @new_template = "Unidentified"
          db_updater(id)
        end
      end

    rescue
      @new_template = @error_code
      db_updater(id)
    end

  end

  def get_result_status
    @current_template = @indexer.template
    if @current_template && @current_template == @new_template
      @template_status = "Same"
    else
      @template_status = "Updated"
    end
  end

  def db_updater(id)
    get_result_status
    puts "\n\n#{"="*30}\ntemplate_status: '#{@template_status}'\nurl: '#{@url}'\ncurrent_template: '#{@current_template}'\nnew_template: '#{@new_template}'\n\n"

    @indexer.update_attributes(indexer_status: "TemplateFinder", template: @new_template, template_date: DateTime.now, template_status: @template_status)

    if id == @last_id
      puts "\n\n===== Last ID: #{id}===== \n\n"
      tf_starter
    end
  end

end
