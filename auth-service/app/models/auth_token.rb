class AuthToken < ApplicationRecord
  belongs_to :user

  scope :valid, -> {
    where(used_at: nil).where("expires_at > ?", Time.current)
  }

  def self.generate_for(user)
    create!(
      user: user,
      token: SecureRandom.hex(16),
      expires_at: 24.hours.from_now
    )
  end

  def use!
    update!(used_at: Time.current)
  end
end
