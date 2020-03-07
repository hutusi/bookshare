# frozen_string_literal: true

namespace :db do
  desc "Dump postgresql database"
  task :dump do
    on roles(:db) do
      execute "source $HOME/.bash_profile && cd #{deploy_to}/current && bundle exec rake db:dump RAILS_ENV=production"
    end
  end
end
