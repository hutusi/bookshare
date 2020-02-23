## 1.3.0
- Tagging books (using gem acts-as-taggable-on): via douban info.
- Add region_code to print_books, users, sharings & borrowings.
- API: Save/return region and reion_code. (redis support)

## 1.2.2
- Bugfix: Fix parse date like '1984.1', etc.

## 1.2.1
- Bugfix: Fix to parse date like '1984-1'
- Bugfix: Fix duplicated importing books for isbn13/isbn10

## 1.2.0
- API: CRUD sharings
- API: CRUD borrowings
- API: Query sharings/borrowings on dashboard
- API: Chanage API model serializer as JSON adapter

## 1.1.0
- API: Create books via ISBN (data from douban)
- API: Update print_books' description.

## 1.0.0
- Rails 6.0, PG, redis, sidekiq, etc.
- Models, Schema ...
- API: CRUD books
- API: CRUD print_books
- API: Query shelfs
- API: CRUD deals
