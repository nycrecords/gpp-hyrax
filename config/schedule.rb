# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

env :PATH, ENV['PATH']

job_type :sidekiq, "cd :path && RAILS_ENV=development bundle exec sidekiq-client :task :output"

every :weekday, at: '7am', roles: [:app] do
  sidekiq "push ReportRequestWorker"
end

every 1.year, at: 'January 1st 12:00am', roles: [:app] do
  sidekiq "push CreateDueDatesWorker"
end
