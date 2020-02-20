# frozen_string_literal: true

namespace :sidekiq do
  # desc "Start the sidekiq"
  # task :start do
  #   on roles(:app) do
  #     execute :sudo, "systemctl start sidekiq"
  #   end
  # end

  # desc "Stop the sidekiq"
  # task :stop do
  #   execute :sudo, "systemctl stop sidekiq"
  # end

  desc "Status of the sidekiq"
  task status: :environment do
    on roles(:app) do
      execute 'systemctl status sidekiq.service'
    end
  end
end
