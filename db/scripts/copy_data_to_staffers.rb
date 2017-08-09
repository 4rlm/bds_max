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
## $ rails runner db/scripts/copy_data_to_staffers.rb
