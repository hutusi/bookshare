# frozen_string_literal: true

namespace :book do
  desc "Fetch books info from douban. "
  task fetch_books_info: :environment do
    save_path = Rails.root.join 'db', 'raw', 'douban', 'books'

    Book.where(data_source: :douban).each do |book|
      isbn = book.isbn
      next if File.exist? File.join(save_path, isbn)

      puts "Fetch book #{isbn} ......"
      FetchDoubanBookService.new(isbn).execute
      sleep 1
    end

    puts "Fetch books info done."
  end

  desc "Renew books info: pubdate. "
  task renew_books_pubdate: :environment do
    save_path = Rails.root.join 'db', 'raw', 'douban', 'books'

    Book.where(data_source: :douban, pubdate: nil).each do |book|
      isbn = book.isbn
      book_path = File.join(save_path, isbn)
      next unless File.exist? book_path

      puts "Update book #{isbn} ..."
      content = File.read book_path
      json = JSON.parse content
      puts "Update book #{isbn} pubdate #{json['pubdate']}......"
      book.update pubdate: json['pubdate']&.try_to_datetime
    end

    puts "Renew books info done."
  end

  desc "Tagging books. "
  task tagging_books: :environment do
    save_path = Rails.root.join 'db', 'raw', 'douban', 'books'

    Book.where(data_source: :douban).each do |book|
      isbn = book.isbn
      book_path = File.join(save_path, isbn)
      next unless File.exist? book_path

      puts "tagging book #{isbn} ..."
      content = File.read book_path
      json = JSON.parse content
      douban_tags = json['tags']
      puts "Tagging book #{isbn} tags: #{douban_tags}......"
      douban_tags&.each do |tag|
        book.tag_list.add(tag['name']) if tag['name'].present?
        book.save
      end
    end

    puts "Tagging books done."
  end
end
