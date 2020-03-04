# frozen_string_literal: true

namespace :db do
  desc "Dump postgresql database"
  task dump: :environment do
    on roles(:db) do
      run "cd #{deploy_to}/current"
      run "bundle exec rake db:dump RAILS_ENV=#{rails_env}"
    end
  end
end
