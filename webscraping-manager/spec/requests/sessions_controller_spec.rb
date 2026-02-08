# frozen_string_literal: true

require "rails_helper"

RSpec.describe SessionsController, type: :request do
  describe "GET /login" do
    it "returns the login page" do
      get "/login"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /register" do
    it "returns the registration page" do
      get "/register"
      expect(response).to have_http_status(:ok)
    end
  end
end
