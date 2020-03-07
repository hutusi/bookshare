# frozen_string_literal: true

namespace :backup do
  desc "Tarball files."
  task tar: :environment do
    puts "tar balls ..."

    tar_file = Rails.root.join 'db', 'backups', "bookshare-db-#{Time.now.utc.to_formatted_s(:number)}.tar.gz"
    tar_path = Rails.root.join 'db', 'dump'
    cmd = "tar -czvf #{tar_file} -C #{tar_path} ."
    puts cmd
    system(cmd)

    tar_file = Rails.root.join 'db', 'backups', "bookshare-books-#{Time.now.utc.to_formatted_s(:number)}.tar.gz"
    tar_path = Rails.root.join 'db', 'raw', 'douban'
    cmd = "tar -czvf #{tar_file} -C #{tar_path} ."
    puts cmd
    system(cmd)

    tar_file = Rails.root.join 'db', 'backups', "bookshare-redis-#{Time.now.utc.to_formatted_s(:number)}.tar.gz"
    tar_path = Rails.root.join 'db', 'raw', 'redis'
    cmd = "tar -czvf #{tar_file} -C #{tar_path} ."
    puts cmd
    system(cmd)

    puts "Tar database and books done."
  end

  desc "Clean dump and backup files."
  task clean: :environment do
    puts "Clean files ..."

    delete_files = Rails.root.join 'db', 'dump', "bookshare-db*.dump"
    cmd = "rm -f #{delete_files}"
    puts cmd
    system(cmd)

    delete_files = Rails.root.join 'db', 'backups', "bookshare-*.tar.gz"
    cmd = "rm -f #{delete_files}"
    puts cmd
    system(cmd)

    puts "Clean backups done."
  end
end
