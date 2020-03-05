# frozen_string_literal: true

namespace :backup do
  desc "Tar balls"
  task :tar do
    on roles(:db) do
      run "cd #{deploy_to}/current"
      run "bundle exec rake backup:tar RAILS_ENV=#{rails_env}"
    end
  end

  desc "Clean backups"
  task :clean do
    on roles(:db) do
      run "cd #{deploy_to}/current"
      run "bundle exec rake backup:clean RAILS_ENV=#{rails_env}"
    end
  end
end
