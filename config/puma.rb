workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

#bind "unix://#{Rails.root}/tmp/sockets/puma.sock"
port  ENV.fetch("PORT") { 3000 }
environment ENV.fetch("RAILS_ENV") { "development" }
pidfile ENV.fetch("PIDFILE") { "tmp/sockets/server.pid" }

on_worker_boot do
  ActiveRecord::Base.establish_connection
end

plugin :tmp_restart

