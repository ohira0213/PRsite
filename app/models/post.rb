class Post < ApplicationRecord
  has_one_attached :post_image
  belongs_to :user
  has_many :favorites, dependent: :destroy

  validates :title, presence: true
  validates :text, presence: true

  def get_post_image(width, height)
    unless post_image.attached?
      file_path = Rails.root.join('app/assets/images/default_post_image.jpg')
      post_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    post_image.variant(resize_to_limit: [width, height]).processed
  end
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
end
