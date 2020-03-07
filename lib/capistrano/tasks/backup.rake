# frozen_string_literal: true

namespace :backup do
  desc "Tar balls"
  task :tar do
    on roles(:db) do
      execute "source $HOME/.bash_profile && cd #{deploy_to}/current && bundle exec rake backup:tar RAILS_ENV=production"
    end
  end

  desc "Clean backups"
  task :clean do
    on roles(:db) do
      execute "source $HOME/.bash_profile && cd #{deploy_to}/current && bundle exec rake backup:clean RAILS_ENV=production"
    end
  end
end
