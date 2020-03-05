# frozen_string_literal: true

namespace :puma do
  # desc "Start the application"
  # task :start do
  #   on roles(:app) do
  #     execute :sudo, "systemctl start puma"
  #   end
  # end

  # desc "Stop the application"
  # task :stop do
  #   execute :sudo, "systemctl stop puma"
  # end

  desc "Status of the application"
  task :status do
    on roles(:app) do
      execute 'systemctl status puma.service'
    end
  end
end
