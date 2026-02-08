class Task < ApplicationRecord
  # Connect to the same DB as Processing Service (by default in docker-compose, both are "webscraping" or separate?)
  # In my docker-compose, Manager has "webscraping_manager" and Processing has "webscraping".
  # I need to connect this specific model to the Processing DB.
  
  establish_connection ENV.fetch("WEBSCRAPING_DB_URL", "postgresql://postgres:postgres@postgres:5432/webscraping")
  
  self.table_name = "scraping_tasks"

  # Enums (must match Processing Service)
  enum :status, {
    pending: "pending",
    processing: "processing",
    completed: "completed",
    failed: "failed"
  }

  validates :url, presence: true
end
