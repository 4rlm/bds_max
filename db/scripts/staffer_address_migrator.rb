# require 'rubygems'

# Author.all.each do |a|
#   user = User.new(
#     :username => a.name.downcase.strip,
#     :encrypted_password => '',
#     :email => '',
#     :avatar_file_name => a.avatar_updated_at,
#     :avatar_content_type => a.avatar_content_type,
#     :avatar_file_size => a.avatar_file_size,
#     :avatar_updated_at => a.avatar_updated_at,
#     :role_id => "3"
#   )
#   user.save!
# end

## From console run :
## $ rails runner db/scripts/staffer_address_migrator.rb


########################

# def migrate_address_to_staffers_btn #=> New Button
#   # @service.migrate_address_to_staffers
#   @service.delay.migrate_address_to_staffers
#   redirect_to admin_developer_path
# end

require 'rubygems'

class StafferAddressMigrator
  def initialize
    puts "\n\n#{"="*40}\nInitializing StafferAddressMigrator ...\n#{"="*40}"
  end

  def start
    # delay.get_indexer_addresses
    # delay.get_core_addresses
    get_indexer_addresses
    get_core_addresses
    # redirect_to admin_developer_path
  end

  ##### INDEXER MIGRATORS START #####
  def get_indexer_addresses
    web_staffers = Staffer.where(cont_source: 'Web', acct_name: nil)
    web_staffers.each do |staffer|
      puts "Inside get_indexer_addresses...#{Process.pid}"
      migrate_indexers_address_to_staffers(staffer)
      # delay.migrate_indexers_address_to_staffers(staffer)
    end
  end

  def migrate_indexers_address_to_staffers(staffer)
    indexer = Indexer.find_by(clean_url: staffer.domain)
    if indexer
      staffer.update_attributes(acct_name: indexer.acct_name, full_address: indexer.full_addr, street: indexer.street, city: indexer.city, state: indexer.state, zip: indexer.zip)
    end
  end

  ##### CORE MIGRATORS START #####
  def get_core_addresses
    crm_staffers = Staffer.where(cont_source: 'CRM', acct_name: nil)
    crm_staffers.each do |staffer|
      puts "Inside get_core_addresses...#{Process.pid}"
      migrate_cores_address_to_staffers(staffer)
      # delay.migrate_cores_address_to_staffers(staffer)
    end
  end

  def migrate_cores_address_to_staffers(staffer)
    core = Core.find_by(sfdc_id: staffer.sfdc_id)
      if core
      staffer.update_attributes(acct_name: core.sfdc_acct, full_address: core.full_address, street: core.sfdc_street, city: core.sfdc_city, state: core.sfdc_state, zip: core.sfdc_zip, domain: core.sfdc_clean_url)
    end
  end

end
######################
staffer_address_migrator = StafferAddressMigrator.new
staffer_address_migrator.start
######################
# $ rails runner db/scripts/staffer_address_migrator.rb
######################

  # def migrate_indexers_address_to_staffers
    # ActiveRecord::Base.connection.execute <<-SQL
    # UPDATE staffers
    # SET acct_name = indexers.acct_name, full_address = indexers.full_addr, street = indexers.street, city = indexers.city, state = indexers.state, zip = indexers.zip
    # FROM indexers
    # WHERE domain = indexers.clean_url;
    # SQL

    ##################################
    # ActiveRecord::Base.connection.execute <<-SQL
    #   UPDATE staffers
    #   SET acct_name = NULL, full_address = NULL, street = NULL, city = NULL, state = NULL, zip = NULL
    #   FROM indexers
    #   WHERE staffers.domain = indexers.clean_url AND staffers.cont_source != 'CRM';
    # SQL
    ##################################
  # end

  # def migrate_cores_address_to_staffers
    # ActiveRecord::Base.connection.execute <<-SQL
    # UPDATE staffers
    # SET acct_name = cores.sfdc_acct, full_address = cores.full_address, street = cores.sfdc_street, city = cores.sfdc_city, state = cores.sfdc_state, zip = cores.sfdc_zip
    # FROM cores
    # WHERE staffers.sfdc_id = cores.sfdc_id AND staffers.cont_source = 'CRM';
    # SQL

    ##################################
    # ActiveRecord::Base.connection.execute <<-SQL
    #   UPDATE staffers
    #   SET acct_name = NULL, full_address = NULL, street = NULL, city = NULL, state = NULL, zip = NULL
    #   FROM cores
    #   WHERE staffers.sfdc_id = cores.sfdc_id AND staffers.cont_source = 'CRM';
    # SQL
    ##################################
  # end
