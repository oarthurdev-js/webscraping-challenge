class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    @tasks = Task.order(created_at: :desc).limit(50)
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = session[:user_id] 
    @task.status = "pending"

    if @task.save      
      trigger_sidekiq_job(@task.id)

      # Notify about task creation
      NotificationClient.notify(
        "task_created",
        @task.id,
        { user_id: @task.user_id },
        { url: @task.url }
      )

      redirect_to tasks_path, notice: "Task created successfully."
    else
      render :new
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_path, notice: "Task deleted."
  end

  private

  def task_params
    params.require(:task).permit(:url, :title)
  end

  def trigger_sidekiq_job(task_id)

    Sidekiq::Client.push(
      'class' => 'ScrapingJob',
      'queue' => 'default',
      'args'  => [task_id]
    )
  rescue StandardError => e
    Rails.logger.error "Failed to enqueue job: #{e.message}"
  end
end
