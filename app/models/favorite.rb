class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :user_id, uniqueness: {scope: :post_id}
  #同じ人が同じ投稿に何度もいいねをできないようにする
end
