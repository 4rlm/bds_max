# require 'rubygems'
# $ rails runner "SampleScriptJob.perform_later"
# $ heroku run rails runner "SampleScriptJob.perform_later" --app bds-max

class SampleScriptJob < ApplicationJob
  queue_as :default
  def perform
    puts "\n\n#{"="*40}\nSampleScriptJob - Initialized!"
    SampleScript.new.delay.sample_script_starter
  end
end
############################################

class SampleScript

  def initialize
    puts "SampleScript - Initialized!\n#{"="*40}"
  end

  def sample_script_starter
    queried_ids = Indexer.select(:id).where.not(staff_url: nil, contact_status: "CS Result").where('scrape_date <= ?', Date.today - 1.day).sort[0...4].pluck(:id)

    nested_ids = queried_ids.in_groups(2)
    nested_ids.each { |ids| delay.nested_iterator(ids) }
    # nested_ids.each { |ids| nested_iterator(ids) }
  end

  def nested_iterator(ids)
    ids.each { |id| template_starter(id) }
    # ids.each { |id| delay.template_starter(id) }
  end

  def template_starter(id)
    indexer = Indexer.find(id)
    view_indexer_current_db_info(indexer)
    # url = indexer.staff_url
    # start_mechanize(url) #=> returns @html
    # html = @html
  end

  def view_indexer_current_db_info(indexer)
    puts "\n=== Current DB Info ===\n"
    puts "indexer_status: #{indexer.indexer_status}"
    puts "template: #{indexer.template}"
    puts "staff_url: #{indexer.staff_url}"
    puts "web_staff_count: #{indexer.web_staff_count}"
    puts "scrape_date: #{indexer.scrape_date}"
    puts "#{"="*30}\n\n"
  end

end
