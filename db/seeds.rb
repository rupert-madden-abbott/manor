# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

admin = Role.find_or_create_by_name :admin
w = Role.find_or_create_by_name :w
ssa = Role.find_or_create_by_name :ssa
dw = Role.find_or_create_by_name :dw
sr = Role.find_or_create_by_name :sr
am = Role.find_or_create_by_name :am
porter = Role.find_or_create_by_name :porter

User.create! [
  { name: 'Martin J Crossley Evans', username: 'gsmjce', roles: [w] },
  { name: 'Paul Sparrow', username: 'bupss', roles: [am] },
  { name: 'Nikki Press', username: 'hrnhp', roles: [ssa] },
  { name: 'Rupert Madden-Abbott', username: 'rm7088', roles: [admin, dw, sr] },
  { name: 'Grant Ray', username: 'gw0667', roles: [sr] },
  { name: 'Ryan Lethem', username: 'rl1595', roles: [sr] },
  { name: 'Andrew Franks', username: 'af6536', roles: [sr] },
  { name: 'Sham Amin', username: 'sa7187', roles: [sr] },
  { name: 'Mina Skelly', username: 'ms9931', roles: [sr] },
  { name: 'Molly Niu', username: 'drxmn', roles: [sr] },
  { name: 'Lisa Collins', username: '', roles: [] },
  { name: 'Will McCready', username: '', roles: [] },
  { name: 'Christine Zhang', username: '', roles: [] },
  { name: 'Dan Thomas', username: '', roles: [porter] },
  { name: 'Roger Parsons', username: 'hrzjp', roles: [porter]
  ]
