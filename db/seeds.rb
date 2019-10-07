# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# if ENV["RAILS_ENV"] == 'develpopment'
# end

users = []

(1..10).each do |i|
  users << User.create!(
    username: Faker::Internet.unique.username,
    email: Faker::Internet.unique.email,
    password: Faker::Internet.password,
    nickname: Faker::Name.name
  )
end

identities = []
(1..10).each do |i|
  identities << Identity.create!(
    provider: :wechat,
    uid: "#{i}",
    user_id: i
  )
end

books = []
book_covers = ['s1988393', 
  's4103521',
  's4047938',
  's33441147',
  's33441355']

(1..10).each do |i|
  books << Book.create!(
    title: Faker::Book.title,
    author: Faker::Book.author,
    publisher: Faker::Book.publisher,
    isbn: Faker::Code.unique.isbn,
    creator_id: rand(1..10),
    cover: "https://img1.doubanio.com/view/subject/l/public/#{book_covers[rand(0..4)]}.jpg"
  )
end
