class Public::RelationshipsController < ApplicationController
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
    @users = user.followings
    if @post.user.is_active == false
      flash[:alert] = "指定された投稿が見つかりません。"
      redirect_to public_posts_path
    end
    @post = user.posts.first
  end

  def followers
    user = User.find(params[:user_id])
    @users = user.followers
    if @post.user.is_active == false
      flash[:alert] = "指定された投稿が見つかりません。"
      redirect_to public_posts_path
    end
    @post = user.posts.first
  end

  private

  def post_comment_params
    params.require(:relationship).permit(:follower_id, :followed_id)
  end
end
