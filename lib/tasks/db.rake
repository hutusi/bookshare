# frozen_string_literal: true

namespace :db do
  desc "Dump postgresql database."
  task dump: :environment do
    timenow = Time.now.utc.to_formatted_s(:number)
    dump_file = Rails.root.join 'db', 'dump',
                                "bookshare-db-#{timenow}.dump"
    puts "Dump database to #{dump_file} ..."

    config   = Rails.configuration.database_configuration
    # host     = config[Rails.env]["host"]
    database = config[Rails.env]["database"]
    username = config[Rails.env]["username"]

    # This dumps the database in Postgres' custom format (-F c) which is
    # compressed by default and allows for reordering of its contents.
    cmd = "pg_dump -F c -U #{username} #{database} -f #{dump_file}"
    puts cmd
    system(cmd)

    puts "Dump database done."
  end

  desc "Restore postgresql database."
  task restore: :environment do
    env = Rails.env.presence || 'development'
    if env != 'development'
      puts "Only can restore development database, return..."
      return
    end

    dump_file = Rails.root.join 'db', 'dump', "bookshare-db.dump"
    puts "Restore database from #{dump_file} ..."

    config   = Rails.configuration.database_configuration
    # host     = config[Rails.env]["host"]
    # database = config[Rails.env]["database"]
    username = config[Rails.env]["username"]

    # -C -c will drop the database if it exists already and then recreate it,
    # helpful in your case. And -v specifies verbose so you can see exactly
    # what's happening when this goes on.
    cmd = "pg_restore -c -C -F c -U #{username} #{dump_file}"
    puts cmd
    system(cmd)

    puts "Restore database done."
  end
end
