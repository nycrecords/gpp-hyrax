module JobUtils
  def self.delete_jobs_in_queue(queue_name, job_ids)
    queue = Sidekiq::Queue.new(queue_name)
    deleted_jobs_count = 0

    queue.each do |job|
      if job_ids.include?(job.jid)
        job.delete
        deleted_jobs_count += 1
      end
    end
    puts "#{deleted_jobs_count} jobs were deleted from the '#{queue_name}' queue."
  end

  def self.show_jobs_in_queue(queue_name)
    queue = Sidekiq::Queue.new(queue_name)
    queue.each do |job|
      puts "Job ID: #{job.jid}, Class: #{job.klass}, Args: #{job.args.inspect}"
    end
  end
end