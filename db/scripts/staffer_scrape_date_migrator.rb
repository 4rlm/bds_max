require 'rubygems'

class StafferScrapeDateMigrator
  def initialize
    puts "\n\n#{"="*40}\nStafferScrapeDateMigrator ...\n#{"="*40}"
  end

  def start
    queried_ids = Staffer.select(:id).where(cont_source: "Web", scrape_date: nil).pluck(:id).sort
    nested_ids = queried_ids.in_groups(5)

    nested_ids.each do |ids|
      nested_iterator(ids)
    end
  end

  def nested_iterator(ids)
    ids.each do |id|
      delay.scrape_date_updater(id)
    end
  end

  def scrape_date_updater(id)
    staffer = Staffer.find(id)
    staffer.update_attributes(scrape_date: staffer.created_at)
  end

end

######################
staffer_scrape_date_migrator = StafferScrapeDateMigrator.new
staffer_scrape_date_migrator.start
######################
# $ rails runner db/scripts/staffer_scrape_date_migrator.rb
# $ heroku run rails runner db/scripts/staffer_scrape_date_migrator.rb --app bds-max
#######################################
