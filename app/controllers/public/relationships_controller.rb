class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    user = User.find(params[:user_id])
    current_user.follow(user)
    redirect_to request.referer
  end

  def destroy
    user = User.find(params[:user_id])
    current_user.unfollow(user)
    redirect_to  request.referer
  end

  def followings
    user = User.find(params[:user_id])
    @users = user.followings.where(is_active: true)
    @post = user.posts.first
    if !@post.nil? && @post.user.is_active?
      flash[:alert] = "指定された投稿が見つかりません。"
      redirect_to public_posts_path
    end
  end

  def followers
    user = User.find(params[:user_id])
    @users = user.followers.where(is_active: true)
    @post = user.posts.first
    if !@post.nil? && @post.user.is_active?
      flash[:alert] = "指定された投稿が見つかりません。"
      redirect_to public_posts_path
    end
  end

  private

  def post_comment_params
    params.require(:relationship).permit(:follower_id, :followed_id)
  end
end
