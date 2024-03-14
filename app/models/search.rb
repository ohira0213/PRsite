class Search < ApplicationRecord
  belongs_to :user
  belongs_to :post
  
  GUEST_USER_EMAIL = "guest@example.com"

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      post.user.password = SecureRandom.urlsafe_base64
      postuser.name = "guestuser"
    end
  end

  def guest_user?
    email == GUEST_USER_EMAIL
  end
  
  def favorites_count
    @favorites = favorites
    @favorites.select{|favorite|favorite if favorite.user.is_active?}.count
  end

  def post_comments_count
    @comments = post_comments
    @comments.select{|comment|comment if comment.user.is_active?}.count
  end
end
