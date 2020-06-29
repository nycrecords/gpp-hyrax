# Laod the environment variables for Puma using Dotenv
require 'dotenv'
Dotenv.load('/opt/hyrax/.env')

# Set the environment in which the rack's app will run. The value must be a string.
#
# The default is "development".
#
environment ENV.fetch("RAILS_ENV") { "development" }


# Use "path" as the file to store the server info state. This is
# used by "pumactl" to query and control the server.
#
state_path "/opt/hyrax/puma.state"

# Store the pid of the server in the file at "path".
#
pidfile "/opt/hyrax/puma.pid"

# === Cluster mode ===

# How many worker processes to run.  Typically this is set to
# to the number of available cores.
#
# The default is "0".
#
workers ENV.fetch("WEB_CONCURRENCY") { 2 }

# Configure "min" to be the minimum number of threads to use to answer
# requests and "max" the maximum.
#
# The default is "5, 5".
#
# threads 5, 5
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

port        ENV.fetch("PORT") { 3000 }

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

plugin :tmp_restart

prune_bundler
