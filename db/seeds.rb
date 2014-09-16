# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#user = CreateAdminService.new.call
#puts 'CREATED ADMIN USER: ' << user.email


puts 'SETTING UP ADMIN ROLE'
admin_role = Role.where(:name => 'Administrator').first_or_create!
puts 'SETTING UP OPERATOR ROLE'
operator_role = Role.where(:name => 'Operator').first_or_create!
puts 'SETTING UP STAFF ROLE'
operator_role = Role.where(:name => 'Staff').first_or_create!

puts 'SETTING UP DEFAULT ADMIN LOGIN'
admin_user = User.where(:email => 'admin@example.com').first_or_create!(:password => 'password', :password_confirmation => 'password')
puts 'New admin user created: ' << admin_user.email

puts 'ASSIGN ROLE TO ADMIN USER'
admin_user.roles << admin_role
admin_user.save
