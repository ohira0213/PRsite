class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image
  has_many :posts
  has_many :favorites, dependent: :destroy

  validates :name, presence: true

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/default_profile_image.png')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  def user_status
    if is_active == false
      "退会"
    else
      "有効"
    end
  end

  def active_for_authentication?
    super && (is_active == true)
    #現在のメソッドの親クラスのメソッドを呼び出している
    #ユーザーがis_activeである場合にのみログインを許可する
  end
end