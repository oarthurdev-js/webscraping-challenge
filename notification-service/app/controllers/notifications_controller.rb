class NotificationsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create] if defined?(verify_authenticity_token)

  def create
    notification = Notification.new(notification_params)

    if notification.save
      Rails.logger.info "Notification created: #{notification.event_type} for Task #{notification.task_id}"
      render json: { message: "Notification received" }, status: :created
    else
      render json: { errors: notification.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    # Optional: List notifications for debugging or if required
    @notifications = Notification.order(created_at: :desc).limit(50)
    render json: @notifications
  end

  private

  def notification_params
    params.require(:notification).permit(:event_type, :task_id, :user_data, :data)
  end
end
