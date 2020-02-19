namespace :db do
  desc "Fetch books info from douban. "
  task fetch_books_info: :environment do
    save_path = Rails.root.join 'db', 'raw', 'douban', 'books'

    Book.where(data_source: :douban).each do |book|
      isbn = book.isbn
      unless File.exists? File.join(save_path, isbn)
        puts "Fetch book #{isbn} ......"
        FetchDoubanBookService.new(isbn).execute
        sleep 1
      end
    end

    puts "Fetch books info done."
  end

  desc "Renew books info: pubdate. "
  task renew_books_info: :environment do
    save_path = Rails.root.join 'db', 'raw', 'douban', 'books'

    Book.where(data_source: :douban, pubdate: nil).each do |book|
      isbn = book.isbn
      book_path = File.join(save_path, isbn)
      if File.exists? book_path
        puts "Update book #{isbn} ..."
        content = File.read book_path
        json = JSON.parse content
        puts "Update book #{isbn} pubdate #{json['pubdate']}......"
        book.update pubdate: json['pubdate']&.try_to_datetime
      end
    end

    puts "Renew books info done."
  end

end
