## $ rails runner "StafferAddressMigratorJob.perform_later"

class StafferAddressMigratorJob < ApplicationJob
  self.queue_adapter = :sidekiq
  # queue_as :critical
  # self.queue_adapter = :delayed_job

  def perform
    puts "\n\n#{"="*40}\nPerforming: StafferAddressMigratorJob ...\n#{"="*40}"
    start
  end

  def start
    get_indexer_addresses
    get_core_addresses
  end

  ##### INDEXER MIGRATORS START #####
  def get_indexer_addresses
    web_staffers = Staffer.where(cont_source: 'Web', acct_name: nil)
    web_staffers.each do |staffer|
      migrate_indexers_address_to_staffers(staffer)
    end
  end

  def migrate_indexers_address_to_staffers(staffer)
    indexer = Indexer.where(clean_url: staffer.domain).where.not(indexer_status: "Archived").first
    if indexer
      staffer.update_attributes(acct_name: indexer.acct_name, full_address: indexer.full_addr, street: indexer.street, city: indexer.city, state: indexer.state, zip: indexer.zip)
      puts "Updated Staffer ID: #{staffer.id} from Indexer ID: #{indexer.id} via PID: #{Process.pid}"
    else
      puts "No Updating - No Indexer"
    end

  end

  ##### CORE MIGRATORS START #####
  def get_core_addresses
    crm_staffers = Staffer.where(cont_source: 'CRM', acct_name: nil)
    crm_staffers.each do |staffer|
      migrate_cores_address_to_staffers(staffer)
    end
  end

  def migrate_cores_address_to_staffers(staffer)
    core = Core.where(sfdc_id: staffer.sfdc_id).first
      if core
      staffer.update_attributes(acct_name: core.sfdc_acct, full_address: core.full_address, street: core.sfdc_street, city: core.sfdc_city, state: core.sfdc_state, zip: core.sfdc_zip, domain: core.sfdc_clean_url)
      puts "Updated Staffer ID: #{staffer.sfdc_id} from Core ID: #{sfdc_id} via PID: #{Process.pid}"
    else
      puts "No Updating - No Core"
    end

  end

end

# StafferAddressMigratorJob.perform_later




########## Original Below ################
# class GuestsCleanupJob < ApplicationJob
#   self.queue_adapter = :sidekiq
#   # queue_as :default
#
#   def perform
#     puts "\n\n===== Inside the GuestsCleanupJob =====\n\n"
#     # cs_starter
#     # results
#     Staffer.cs_starter
#
#     # 8000.times { greeter }
#   end
#
#   def cs_starter
#     queried_ids = Indexer.select(:id).where.not(staff_url: nil, contact_status: "CS Result").where('scrape_date <= ?', Date.today - 1.day).sort.pluck(:id)
#     @queried_ids_count = queried_ids.count
#     queried_ids.each { |id| template_starter(id) }
#   end
#
#   def template_starter(id)
#     indexer = Indexer.find(id)
#     view_indexer_current_db_info(indexer)
#   end
#
#   def view_indexer_current_db_info(indexer)
#     puts "\n=== Current DB Info ===\n"
#     puts "indexer_status: #{indexer.indexer_status}"
#     puts "template: #{indexer.template}"
#     puts "staff_url: #{indexer.staff_url}"
#     puts "web_staff_count: #{indexer.web_staff_count}"
#     puts "scrape_date: #{indexer.scrape_date}"
#     puts "#{"="*30}\n\n"
#   end
#
#   def results
#     puts "\n\n ====== queried_ids_count: #{@queried_ids_count} ======\n\n"
#   end
#
# end
#
# # GuestsCleanupJob.perform_later
