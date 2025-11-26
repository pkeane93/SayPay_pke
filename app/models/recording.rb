class Recording < ApplicationRecord
  belongs_to :trip
  has_many :expenses, dependent: :destroy

  has_one_attached :audio

  # validate acceptable audio file types
  validate :acceptable_audio

  # TODO: check that audio file is maximum 1 min long

  private

  def acceptable_audio
    return unless audio.attached?

    unless audio.byte_size <= 5.megabytes
      errors.add(:audio, "is too big. Maximum size is 5MB.")
    end

    acceptable_types = %w[audio/webm audio/ogg audio/wav audio/mpeg audio/mp4]
    unless acceptable_types.include?(audio.content_type)
      errors.add(:audio, "must be an audio file (webm/ogg/wav/mp3)")
    end
  end
end
