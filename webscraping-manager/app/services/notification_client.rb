class NotificationClient
  include HTTParty
  
  base_uri ENV.fetch("NOTIFICATION_SERVICE_URL", "http://localhost:3003")

  def self.notify(event_type, task_id, user_data = {}, data = {})
    response = post("/notifications", 
      body: { 
        notification: {
          event_type: event_type, 
          task_id: task_id, 
          user_data: user_data, 
          data: data 
        } 
      }.to_json, 
      headers: { "Content-Type" => "application/json" }
    )
    
    if response.success?
      true
    else
      Rails.logger.error "Failed to send notification: #{response.body}"
      false
    end
  rescue StandardError => e
    Rails.logger.error "Notification Service Error: #{e.message}"
    false
  end
end
