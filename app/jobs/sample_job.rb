class SampleJob < ApplicationJob
  queue_as :default

  def perform
    StafferScrapeDateMigrator.new
  end

  # def perform(*args)
  #   puts "hello-bye!"
  #   puts "This is a sample delayed job!!!=="
  #   @name = "Adam"
  #   greeter
  # end

  # def perform(name)
  #   puts "hello-bye!"
  #   puts "This is a sample delayed job!!!=="
  #   @name = name
  #   greeter
  # end

  # def perform
  #   puts "hello-bye!"
  #   puts "This is a sample delayed job!!!=="
  #   @name = name
  #   greeter
  # end

  # def greeter
  #   puts "Wow!=========\n\n"
  #   puts @name
  # end

  # def perform
  #   counter
  # end

  # def counter
  #   queried_ids = Indexer.select(:id).where.not(staff_url: nil, contact_status: "CS Result").where('scrape_date <= ?', Date.today - 1.day).sort.pluck(:id)
  #
  #   puts "Queried ID Count: #{queried_ids.count}"
  # end

end
