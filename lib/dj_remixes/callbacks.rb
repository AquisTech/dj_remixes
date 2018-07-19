module DJ
  class Worker

    def before(job)
      self.dj_object = job
      job.persisted? ? job.touch(:started_at) : job.started_at = Time.now.utc
    end

    def after(job)
    end

    def success(job)
      job.persisted? ? job.touch(:finished_at) : job.finished_at = Time.now.utc
      self.enqueue_again if self.respond_to?(:enqueue_again)
    end

    def error(job, error)
      job.update_attributes(:started_at => nil)
    end

  end # Worker
end # DJ