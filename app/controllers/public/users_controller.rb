class Public::UsersController < ApplicationController
  before_action :ensure_guest_user, only: [:edit, :edit, :favorite, :confirm]

  def show
    @user = User.find(params[:id])
    if @user.is_active == false
      flash[:alert] = "指定された投稿が見つかりません。"
      redirect_to public_posts_path
    end
    @posts = @user.posts
    @avorites = Favorite.joins(:user).where("users.is_active <> ? ",false)
    @post_comment = PostComment.new
  rescue ActiveRecord::RecordNotFound
  #user_idが見つからない時は、nilを返す
    @user = nil
    flash[:alert] = "指定されたユーザーが見つかりません。"
    redirect_to public_posts_path
  end

  def edit
    @user = User.find(params[:id])
    if @user.is_active == false
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
      error_messages = []
      # エラーメッセージを格納するための配列を初期化
      error_messages << "ユーザー名を入力してください。" if user_params[:name].blank?
      # ユーザー名に関するエラーが存在する場合
      error_messages << "自己紹介文は15文字以内で入力してください。" if user_params[:introduction].to_s.length > 15
      # PR文に関するエラーが存在する場合
      flash[:alert] = "プロフィールの変更ができませんでました。" + error_messages.join(" ") unless error_messages.empty?
      redirect_to edit_public_user_path(@user.id)
    end
  end

  def favorite
    @user = User.find(params[:user_id])
    @favorites = @user.favorites
    if @user.is_active == false
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

  def user_params
    params.require(:user).permit(:name,:introduction, :email, :password, :is_active, :profile_image)
  end
end
