class Message < ApplicationRecord
  belongs_to :chat

  validates :role, presence: true, inclusion: { in: %w[user assistant system] }
  validates :content, presence: true
end
