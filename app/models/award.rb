class Award < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true

  validates :name, presence: true

  validate :image_url_format

  has_one_attached :image

  private

  def image_url_format
    errors.add(:image, "must be a URL for GIF, JPG or PNG image") unless image.filename.to_s.match? %r{\.(png|jpg|jpeg)\z}
  end
end
