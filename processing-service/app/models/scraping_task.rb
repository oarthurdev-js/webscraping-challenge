class ScrapingTask < ApplicationRecord
  enum :status, {
    pending: "pending",
    processing: "processing",
    completed: "completed",
    failed: "failed"
  }

  validates :url, presence: true
  validates :status, presence: true

  def parsed_result
    return nil if result.blank?

    JSON.parse(result)

  rescue JSON::ParserError
    nil
  end

  def as_json(options = {})
    super(
      only: [:id, :url, :status, :created_at, :updated_at],
      methods: [:parsed_result]
    )
  end
end