# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
p format('Starting seed with %d recruiters', Recruiter.count)


#
# Helpers
#
def random_phone_number
  (10.times.collect{ |n| rand(0..9).to_s }).join('')
end

$timer = Time.now.to_f
def split_timer(msg)
  last_split = $timer
  this_split = Time.now.to_f
  $timer = this_split
  p format('%s: %.2f s', msg, this_split - last_split)
end


#
# Create lists
#
RecruiterList.where(name: 'Seeded').destroy_all
seeded_list = RecruiterList.create!(name: 'Seeded')
split_timer('Created recruiter list')


#
# Create recruiters
#
recruiters = [
  ['Jill', 'Monger', 'Cyber Recruiters'],
  ['Jack', 'Slinger', 'Half Robot Technology']
]

recruiters.each do | first_name, last_name, company |
  email = format('%s.%s@%s.com',
                 first_name.downcase,
                 last_name.downcase,
                 company.delete(' ').downcase)
  recruiter = Recruiter.find_by_email(email)
  recruiter.destroy unless recruiter.nil?

  recruiter = Recruiter.create!(first_name: first_name,
                                last_name: last_name,
                                email: email,
                                company: company,
                                phone: random_phone_number,
                                recruiter_list_id: seeded_list.id)

  new_ping = {
    recruiter_id: recruiter.id,
    kind: 'spam',
    note: 'Added by seed file',
    date: Date.today
  }
  Ping.create!(new_ping)
end
split_timer('Created 2 recruiters')

p format('Ending seed with %d recruiters', Recruiter.count)
