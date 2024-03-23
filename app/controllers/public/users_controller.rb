class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user, only: [:edit, :favorite, :confirm]

  def show
    @user = User.find(params[:id])
    if @user.is_active == false || (@user.email == "guest@example.com" && current_user != @user) || (current_user.email == "guest@example.com" && @user.is_active == false)
    #is_activeがfalseのユーザーまたはゲストユーザーは（ゲストユーザー自身が開いた場合を除いて）開けない
      flash[:alert] = "指定されたユーザーが見つかりません。"
      redirect_to public_posts_path
    end
    @posts = @user.posts.order(created_at: :desc)
    @post_comment = PostComment.new
  rescue ActiveRecord::RecordNotFound
  #user_idが見つからない時は、nilを返す
    @user = nil
    flash[:alert] = "指定されたユーザーが見つかりません。"
    redirect_to public_posts_path
  end

  def edit
    @user = User.find(params[:id])
    if !@user.is_active? || guest_user?(@user)
      flash[:alert] = "指定されたユーザーが見つかりません。"
      redirect_to public_posts_path
    end
    if @user != current_user
    #指定されたuser_idがログイン中のuser_idと異なった場合は開けない
      flash[:alert] = "アクセスできません。"
      redirect_to public_posts_path
    end
  rescue ActiveRecord::RecordNotFound
  #指定されたuser_idが見つからない時は、nilを返す
    @user = nil
    flash[:alert] = "アクセスできません。"
    redirect_to public_posts_path
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "プロフィールを変更しました。"
      redirect_to public_user_path(@user)
    else
      if user_params[:name].blank?
        flash[:alert] = "ユーザー名を入力してください。"
      end
      if user_params[:name].to_s.length > 10
        flash[:alert] = "ユーザー名は10文字以内で入力してください。"
      end
      if user_params[:introduction].to_s.length > 20
        flash[:alert] ||= ""
        flash[:alert] += "メッセージは20文字以内で入力してください。"
      end
      redirect_to request.referer and return if flash[:alert].present?
    end
  end

  def favorite
    @user = User.find(params[:user_id])
    @favorites = @user.favorites.order(created_at: :desc)
    if !@user.is_active? || guest_user?(@user)
      flash[:alert] = "指定されたユーザーが見つかりません。"
      redirect_to public_posts_path
    end
    @post_comment = PostComment.new
  rescue ActiveRecord::RecordNotFound
  #指定されたuser_idまたはpost_idが見つからない時は、nilを返す
    @user = nil
    flash[:alert] = "アクセスできません。"
    redirect_to public_posts_path
  end

  def confirm
  end

  def withdrawal
    current_user.update(is_active: false)
    reset_session
    flash[:notice] = "退会しました。またのご利用お待ちしております。"
    redirect_to public_root_path
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

  def user_params
    params.require(:user).permit(:name,:introduction, :email, :password, :is_active, :profile_image)
  end
end
