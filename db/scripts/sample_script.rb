require 'rubygems'

class SampleScript
  ### TRY .SELF ###

  # def perform
  # def initialize
  #   puts "We are in the Starter!"
  # end

  def greeter
    puts "In the greeter!"
  end

  # def perform
  #   # counter_test
  #   array = (0..20).to_a
  #   array.each { |num| puts num }
  # end


  # def initialize
  #   puts "\n\n#{"="*40}\nStafferScrapeDateMigrator ...\n#{"="*40}"
  # end

  # def counter_test
  #   array = (0..20).to_a
  #   array.each { |num| puts num }
  # end

  # def start
    # puts "where are we?"
    # queried_ids = Staffer.select(:id).where(cont_source: "Web", scrape_date: nil).pluck(:id).sort
    # nested_ids = queried_ids.in_groups(5)
    #
    # nested_ids.each do |ids|
    #   nested_iterator(ids)
    # end
  # end

  # def nested_iterator(ids)
  #   ids.each do |id|
  #     scrape_date_updater(id)
  #   end
  # end

  # def scrape_date_updater(id)
  #   staffer = Staffer.find(id)
  #   staffer.update_attributes(scrape_date: staffer.created_at)
  # end

end

# klz = SampleScript.new
# klz.starter


class ClassStarter
  # queue_as :default
  def perform
    puts "Hi!  In the ClassStarter!"
    # SampleScript.new.greeter
  end
end

Delayed::Job.enqueue ClassStarter.new


# Delayed::Job.enqueue SampleScript.new


# $ rails runner db/scripts/sample_script.rb


######################
# staffer_scrape_date_migrator = StafferScrapeDateMigrator.new
# staffer_scrape_date_migrator.delay.start

# Delayed::Job.enqueue SampleScript.new
######################
# $ rails runner db/scripts/staffer_scrape_date_migrator.rb
# $ heroku run rails runner db/scripts/staffer_scrape_date_migrator.rb --app bds-max
#######################################
