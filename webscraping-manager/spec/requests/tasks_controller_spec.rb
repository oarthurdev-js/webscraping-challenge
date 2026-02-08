# frozen_string_literal: true

require "rails_helper"

RSpec.describe TasksController, type: :request do
  before do
    # Mock authentication
    allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(1)
  end

  describe "GET /tasks" do
    it "returns the tasks index page" do
      get "/tasks"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /tasks/new" do
    it "returns the new task form" do
      get "/tasks/new"
      expect(response).to have_http_status(:ok)
    end
  end
end
