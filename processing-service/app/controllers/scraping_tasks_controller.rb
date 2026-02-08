class ScrapingTasksController < ApplicationController
  def index
    tasks = ScrapingTask.order(created_at: :desc)
    render json: tasks
  end

  def show
    task = ScrapingTask.find(params[:id])
    render json: task
  end

  def create
    task = ScrapingTask.create!(
      url: params[:url],
      status: "pending"
    )

    ScrapingJob.perform_later(task.id)

    render json: task, status: :created
  end
end
