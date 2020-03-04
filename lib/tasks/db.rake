# frozen_string_literal: true

namespace :db do
  desc "Dump postgresql database."
  task dump: :environment do
    dump_file = Rails.root.join 'db', 'dump', "bookshare-db-#{Time.now.utc.to_formatted_s(:number)}.dump"
    puts "Dump database to #{dump_file} ..."

    env = ENV["RAILS_ENV"].presence || 'development'
    yml = YAML.load_file('config/database.yml')[env]

    # This dumps the database in Postgres' custom format (-F c) which is compressed by default
    # and allows for reordering of its contents.
    cmd = "pg_dump -F c -U #{yml['username']} -h localhost #{yml['database']} -f #{dump_file}"
    system(cmd)

    puts "Dump database done."
  end

  desc "Restore postgresql database."
  task restore: :environment do
    env = ENV["RAILS_ENV"].presence || 'development'
    if env != 'development'
      puts "Only can restore development database, return..."
      return
    end

    dump_file = Rails.root.join 'db', 'dump', "bookshare-db.dump"
    puts "Restore database from #{dump_file} ..."

    yml = YAML.load_file('config/database.yml')[env]

    # -C -c will drop the database if it exists already and then recreate it, helpful in your case.
    # -->deleted: And -v specifies verbose so you can see exactly what's happening when this goes on.
    cmd = "pg_restore -c -C -F c -U #{yml['username']} -h localhost #{dump_file}"
    system(cmd)

    puts "Restore database done."
  end
end
