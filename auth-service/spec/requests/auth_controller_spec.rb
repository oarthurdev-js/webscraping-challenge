# frozen_string_literal: true

require "rails_helper"

RSpec.describe AuthController, type: :request do
  describe "POST /auth/register" do
    it "creates a new user" do
      post "/auth/register", params: { email: "test@example.com", password: "password123" }
      
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["message"]).to eq("User created successfully")
    end

    it "returns error for duplicate email" do
      User.create!(email: "existing@example.com", password: "password123")
      
      post "/auth/register", params: { email: "existing@example.com", password: "password123" }
      
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "POST /auth/login" do
    let!(:user) { User.create!(email: "user@example.com", password: "password123") }

    it "returns a JWT token for valid credentials" do
      post "/auth/login", params: { email: "user@example.com", password: "password123" }
      
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to have_key("token")
    end

    it "returns error for invalid credentials" do
      post "/auth/login", params: { email: "user@example.com", password: "wrongpassword" }
      
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "POST /auth/verify" do
    let!(:user) { User.create!(email: "user@example.com", password: "password123") }

    it "verifies a valid token" do
      post "/auth/login", params: { email: "user@example.com", password: "password123" }
      token = JSON.parse(response.body)["token"]

      post "/auth/verify", params: { token: token }
      
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to have_key("user_id")
    end

    it "returns error for invalid token" do
      post "/auth/verify", params: { token: "invalid_token" }
      
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
