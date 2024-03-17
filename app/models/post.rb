class Post < ApplicationRecord
  has_one_attached :post_image
  belongs_to :user

  has_many :favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :searchs, dependent: :destroy

  validates :text, presence: true, length: { maximum: 100 }

  def get_post_image(width, height)
    unless post_image.attached?
      file_path = Rails.root.join('app/assets/images/default_post_image.jpg')
      post_image.attach(io: File.open(file_path), filename: 'default_post_image.jpg', content_type: 'image/jpg')
    end
    post_image.variant(resize_to_limit: [width, height]).processed
  end

  def favorited_by?(current_user)
    favorites.exists?(user_id: current_user.id)
  end

  def favorites_count
    @favorites = favorites
    @favorites.select{|favorite|favorite if favorite.user.is_active?}.count
  end

  def post_comments_count
    @comments = post_comments
    @comments.select{|comment|comment if comment.user.is_active?}.count
  end

  GUEST_USER_EMAIL = "guest@example.com"

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      post.user.password = SecureRandom.urlsafe_base64
      post.user.name = "ゲスト"
    end
  end

  def guest_user?
    email == GUEST_USER_EMAIL
  end

  def self.looks(search, word)
    if search == "perfect_match"
      @post = Post.where("text LIKE?","#{word}")
    elsif search == "partial_match"
      @post = Post.where("text LIKE?","%#{word}%")
    end
  end
end
