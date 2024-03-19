class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image
  has_many :posts
  has_many :favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :searchs, dependent: :destroy
  has_one :request, dependent: :destroy

  validates :email, uniqueness: true
  validates :name, presence: true, length: { maximum: 10 }
  validates :introduction, length: { maximum: 20 }

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join("app/assets/images/default_profile_image.png")
      profile_image.attach(io: File.open(file_path), filename: "default_profile_image.png", content_type: "image/png")
    end
    profile_image.variant(resize_to_fill: [width, height, gravity: "Center"]).processed
    #指定したサイズに合わせて中心から画像を縮小・拡大し、余剰部分をトリミングする
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

  def follow(user)
    active_relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  def followers_count
    @followers = followers
    @followers.select{|follower|follower if follower.is_active?}.count
  end

  def followings_count
    @followings = followings
    @followings.select{|following|following if following.is_active?}.count
  end

  def has_request?
  #self.requestが存在するかどうかを確認
    self.request.present?
    #self.request（@userの申請情報）が存在する場合にtrueを返す
  end

  def user_status
    if is_active == true
      "継続中"
    else
      "退会済"
    end
  end

  def active_for_authentication?
    super && (is_active == true)
    #現在のメソッドの親クラスのメソッドを呼び出している
    #ユーザーがis_activeである場合にのみログインを許可する
  end

  GUEST_USER_EMAIL = "guest@example.com"

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲスト"
    end
  end

  def guest_user?
    email == GUEST_USER_EMAIL
  end

  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?","#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    end
  end
end