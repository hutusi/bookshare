#!/usr/bin/env puma

directory '/home/deploy/bookshare/current'
rackup "/home/deploy/bookshare/current/config.ru"
environment 'production'

tag ''

pidfile "/home/deploy/bookshare/shared/tmp/pids/puma.pid"
state_path "/home/deploy/bookshare/shared/tmp/pids/puma.state"
stdout_redirect '/home/deploy/bookshare/shared/log/puma_access.log', '/home/deploy/bookshare/shared/log/puma_error.log', true

threads 0,16


bind 'unix:///home/deploy/bookshare/shared/tmp/sockets/puma.sock'

workers 0

prune_bundler


on_restart do
  puts 'Refreshing Gemfile'
  ENV["BUNDLE_GEMFILE"] = ""
end
