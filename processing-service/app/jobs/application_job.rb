class ApplicationJob < ActiveJob::Base
  queue_as :default

  def perform(scraping_task_id)
    task = ScrapingTask.find(scraping_task_id)

    task.update!(status: "Processing")

    data = WebmotorsScraper.call(task.url)

    task.update!(
      status: "Completed",
      data: data,
      finished_at: Time.current
    )
  rescue StandardError => e
    task.update!(
      status: "Failed",
      error_message: e.message,
      finished_at: Time.current
    )
    raise e
  end
end
