class StafferScrapeDateMigratorJob < ApplicationJob
  queue_as :default

  def perform
    # puts "\n\n#{"="*40}\nStafferScrapeDateMigrator ...\n#{"="*40}"
    start
  end

  def start
    array = (0..200).to_a
    array.each do |num|
      num_putter(num)
    end
  end

  def num_putter(num)
    puts "\n\nnum: #{num}\n\n"
  end

  # def start
  #   queried_ids = Indexer.select(:id).where.not(staff_url: nil, contact_status: "CS Result").where('scrape_date <= ?', Date.today - 1.day).sort[0..50].pluck(:id)
  #
  #   nested_ids = queried_ids.in_groups(10)
  #   nested_ids.each { |ids| nested_iterator(ids) }
  # end

  # def nested_iterator(ids)
  #   ids.each { |id| delay.scrape_date_updater(id) }
  # end

  # def scrape_date_updater(id)
  #   puts "\n\nID: #{id}\n\n"
  #   # staffer = Staffer.find(id)
  #   # staffer.update_attributes(scrape_date: staffer.created_at)
  # end

  # def say_goodbye
  #   puts "Completed DJ: StafferScrapeDateMigratorJob"
  #   # puts "\n\n=== Completed DJ: StafferScrapeDateMigratorJob ===\n\n"
  # end

end

# StafferScrapeDateMigratorJob.new
