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

# Schedule runs everyday at 9:00 am to check all license keys
every 1.day, at: '12:00 am' do
  runner "LicenseKeyCheckJob.perform_later"
end

every :month, at: 'end of the month at: 23:59' do
  runner "GenerateInvoicesJob.perform_later"
end

  