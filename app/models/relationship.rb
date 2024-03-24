class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  def followers_count
    @followers = followers
    @followers.select{|follower|follower if follower.is_active?}.count
  end

  def followings_count
    @followings = followings
    @followings.select{|following|following if following.is_active?}.count
  end
end
