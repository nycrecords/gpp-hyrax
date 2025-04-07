task :run_report_request_worker_job => :environment do
  retry_setting = ReportRequestWorker.get_sidekiq_options['retry']
  queue_name = ReportRequestWorker.get_sidekiq_options['queue']
  jid = ReportRequestWorker.perform_async

  puts "Posted ReportRequestWorker to queue '#{queue_name}', Job ID : #{jid}, Retry : #{retry_setting}"
end