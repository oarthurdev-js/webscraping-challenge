class ScrapingJob
  include Sidekiq::Job
  sidekiq_options queue: :default

  def perform(scraping_task_id)
    task = ScrapingTask.find(scraping_task_id)

    task.update!(status: "processing")

    data = WebmotorsScraper.call(task.url)

    

    task.update!(
      status: "completed",
      result: data.to_json,
      finished_at: Time.current
    )

    NotificationClient.notify(
      "task_completed",
      task.id,
      { user_id: task.user_id },
      data
    )
  rescue StandardError => e
    task.update!(
      status: "failed",
      error_message: e.message,
      finished_at: Time.current
    )
    
    NotificationClient.notify(
      "task_failed",
      task.id,
      { user_id: task.user_id },
      { error: e.message }
    )
    
    raise e
  end
end