# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

admin = Role.find_or_create_by_name :admin
staff = Role.find_or_create_by_name :staff
dw = Role.find_or_create_by_name :dw
sr = Role.find_or_create_by_name :sr
manor = Role.find_or_create_by_name :manor
richmond = Role.find_or_create_by_name :richmond

[
  { name: 'Martin J Crossley Evans', username: 'gsmjce',
    roles: [staff, manor] },
  { name: 'Paul Sparrow', username: 'bupss', roles: [staff, manor] },
  { name: 'Nikki Press', username: 'hrnhp', roles: [staff, manor] },
  { name: 'Rupert Madden-Abbott', username: 'rm7088',
    roles: [admin, dw, manor] },
  { name: 'Grant Ray', username: 'gw0667', roles: [sr, manor] },
  { name: 'Ryan Lethem', username: 'rl1595', roles: [sr, manor] },
  { name: 'Andrew Franks', username: 'af6536', roles: [sr, manor] },
  { name: 'Sham Amin', username: 'sa7187', roles: [sr, manor] },
  { name: 'Mina Skelly', username: 'ms9931', roles: [sr, manor] },
  { name: 'Molly Niu', username: 'drxmn', roles: [sr, manor] },
  { name: 'Lisa Collins', username: 'lc0320', roles: [dw, richmond] },
  { name: 'Will McCready', username: 'wm8196', roles: [sr, richmond] },
  { name: 'Christine Zhang', username: 'eexnz', roles: [sr, richmond] },
  { name: 'Dan Thomas', username: 'dt12491', roles: [staff, manor] },
  { name: 'Roger Parsons', username: 'hrzjp', roles: [staff, manor] }
].each do |user|
  User.find_or_create_by_username! user
end
