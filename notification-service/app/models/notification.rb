class Notification < ApplicationRecord
  validates :event_type, presence: true
  validates :task_id, presence: true
end
