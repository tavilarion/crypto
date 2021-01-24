workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads 1, Integer(ENV['MAX_THREADS'] || 5)

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  ActiveRecord::Base.establish_connection
end
