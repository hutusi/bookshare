# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# if ENV["RAILS_ENV"] == 'develpopment'
# end

ActiveRecord::Base.transaction do

  users = []

  (1..10).each do |i|
    users << User.create!(
      username: Faker::Internet.unique.username,
      email: Faker::Internet.unique.email,
      password: Faker::Internet.password,
      nickname: Faker::Name.name,
      api_token: "#{i}"
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

  (1..100).each do |i|
    books << Book.create!(
      title: Faker::Book.title,
      author: Faker::Book.author,
      publisher: Faker::Book.publisher,
      isbn: Faker::Code.unique.isbn,
      creator_id: rand(1..10),
      cover: "https://img1.doubanio.com/view/subject/l/public/#{book_covers[rand(0..4)]}.jpg"
    )
  end

  print_books = []
  (1..100).each do |i|
    user_id = rand(1..3)
    print_books << PrintBook.create!(
      book_id: i,
      owner_id: user_id,
      holder_id: user_id,
      creator_id: user_id
    )
  end

  (1..40).each do |i|
    print_books[i-1].update!(property: :personal)
  end

  (41..70).each do |i|
    print_books[i-1].update!(property: :borrowable)

    (50..65).each do |j|
      if print_books[j].owner_id == 1
        print_books[j].holder_id = 2
      else
        print_books[j].holder_id = 1
      end
    end
  end

  (71..100).each do |i|
    print_books[i-1].update!(property: :shared)

    (80..95).each do |j|
      if print_books[j].owner_id == 1
        print_books[j].holder_id = 2
      else
        print_books[j].holder_id = 1
      end
    end
  end

end # transaction
