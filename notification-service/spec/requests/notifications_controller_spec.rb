# frozen_string_literal: true

require "rails_helper"

RSpec.describe NotificationsController, type: :request do
  describe "POST /notifications" do
    it "creates a task_created notification" do
      post "/notifications", params: {
        notification: {
          event_type: "task_created",
          task_id: 1,
          user_data: { user_id: 1 },
          data: { url: "https://example.com" }
        }
      }

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["message"]).to eq("Notification received")
    end

    it "creates a task_completed notification" do
      post "/notifications", params: {
        notification: {
          event_type: "task_completed",
          task_id: 1,
          user_data: { user_id: 1 },
          data: { brand: "Honda", model: "Civic", price: "R$ 80.000" }
        }
      }

      expect(response).to have_http_status(:created)
      expect(Notification.last.event_type).to eq("task_completed")
    end

    it "creates a task_failed notification" do
      post "/notifications", params: {
        notification: {
          event_type: "task_failed",
          task_id: 1,
          user_data: { user_id: 1 },
          data: { error: "Connection timeout" }
        }
      }

      expect(response).to have_http_status(:created)
      expect(Notification.last.event_type).to eq("task_failed")
    end

    it "validates presence of event_type" do
      post "/notifications", params: {
        notification: {
          task_id: 1
        }
      }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
