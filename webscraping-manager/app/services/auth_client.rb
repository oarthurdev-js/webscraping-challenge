class AuthClient
  include HTTParty
  
  # Default to localhost if env not set (for development outside docker)
  base_uri ENV.fetch("AUTH_SERVICE_URL", "http://localhost:3001")

  def self.login(email, password)
    response = post("/auth/login", body: { email: email, password: password }.to_json, headers: { "Content-Type" => "application/json" })
    
    if response.success?
      { success: true, token: response["token"] }
    else
      { success: false, error: response["error"] || "Login failed" }
    end
  end

  def self.register(email, password)
    response = post("/auth/register", body: { email: email, password: password }.to_json, headers: { "Content-Type" => "application/json" })
    
    if response.success?
      { success: true }
    else
      { success: false, errors: response["errors"] || ["Registration failed"] }
    end
  end

  def self.verify(token)
    response = post("/auth/verify", body: { token: token }.to_json, headers: { "Content-Type" => "application/json" })
    
    if response.success?
      { success: true, user_id: response["user_id"] }
    else
      { success: false }
    end
  end
end
