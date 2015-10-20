# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# populate database with fake data
User.create!( name:  "Example User",
              email: "example@test.org",
              password:              "123456",
              password_confirmation: "123456",
              admin: true,
              activated: true,
              activated_at: Time.zone.now )

100.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@test.org"
  password = SecureRandom.base64(12)
  User.create!( name:  name,
                email: email,
                password:              password,
                password_confirmation: password,
                activated: true,
                activated_at: Time.zone.now )
end

users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(10)
  users.each { |user| user.microposts.create!(content: content) }
end

# following/follower
users = User.all
user = users.first
following = users[2..25]
followers = users[26..50]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }