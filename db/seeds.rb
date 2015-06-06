# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
list = RecruiterList.create!(name: 'Seeded')

jill = Recruiter.create!(first_name: 'Jill',
                         last_name: 'Monger',
                         email: 'jill.monger@cyberrecruiters.com',
                         company: 'Cyber Recruiters',
                         phone: '5555551212',
                         recruiter_list_id: list.id)
jack = Recruiter.create!(first_name: 'Jack',
                         last_name: 'Slinger',
                         email: 'jack.slinger@halfrobottechnology.com',
                         company: 'Half Robot Technology',
                         phone: '5555551213',
                         recruiter_list_id: list.id)

new_ping = {
  kind: 'spam',
  note: 'Added by seed file',
  date: Date.today
}
Ping.create!(new_ping.merge(recruiter_id: jill.id))
Ping.create!(new_ping.merge(recruiter_id: jack.id))
