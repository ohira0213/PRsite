class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:user_id])
    current_user.follow(@user)
    redirect_to request.referer
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(@user)
    redirect_to  request.referer
  end

  def followings
    @user = User.find(params[:user_id])
    @users = @user.followings.where(is_active: true)
    if !@user.is_active? || guest_user?(@user)
      flash[:alert] = "指定されたユーザーが見つかりません。"
      redirect_to public_posts_path
    end
  rescue ActiveRecord::RecordNotFound
  #指定されたuser_idが見つからない時は、nilを返す
    @user = nil
    flash[:alert] = "アクセスできません。"
    redirect_to public_posts_path
  end

  def followers
    @user = User.find(params[:user_id])
    @users = @user.followers.where(is_active: true)
    if !@user.is_active? || guest_user?(@user)
      flash[:alert] = "指定されたユーザーが見つかりません。"
      redirect_to public_posts_path
    end
  rescue ActiveRecord::RecordNotFound
  #指定されたuser_idが見つからない時は、nilを返す
    @user = nil
    flash[:alert] = "アクセスできません。"
    redirect_to public_posts_path
  end

  private
  
  def ensure_guest_user
    if current_user.email == "guest@example.com"
      flash[:alert] = "ゲストユーザーは一部閲覧のみ可能です。"
      redirect_to public_user_path(current_user)
    end
  end

  def guest_user?(user)
    user.email == "guest@example.com"
  end

  def post_comment_params
    params.require(:relationship).permit(:follower_id, :followed_id)
  end
end
