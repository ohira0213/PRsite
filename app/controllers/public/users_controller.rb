class Public::UsersController < ApplicationController
  def show
    @favorites = current_user.favorites
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
  #user_idが見つからない時は、nilを返す
    @user = nil
    flash[:error] = "指定されたユーザーが見つかりません"
    redirect_to public_posts_path
  end

  def edit
    @user = User.find(params[:id])
    if @user != current_user
    #指定されたuser_idがログイン中のuser_idと異なった場合は開けない
      flash[:error] = "アクセスできません"
      redirect_to public_posts_path
    end
  rescue ActiveRecord::RecordNotFound
  #指定されたuser_idが見つからない時は、nilを返す
    @user = nil
      flash[:error] = "アクセスできません。"
    redirect_to public_posts_path
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "プロフィールを変更しました。"
      redirect_to public_user_path(@user.id)
    else
      flash[:error] = "プロフィールの変更に失敗しました。"
      redirect_to edit_public_user_path
    end
  end

  def withdrawal
    if current_user
      @user = User.find_by(id: current_user.id)
      if @user
        @user.update(is_active: false)
        flash[:notice] = "退会しました。またのご利用お待ちしております。"
        redirect_to user_session_path
      else
        flash[:error] = "アクセスできません。ユーザー登録してください。"
        redirect_to public_root_path
      end
    else
      flash[:error] = "アクセスできません。ログインしてください。"
      redirect_to user_session_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :is_active, :profile_image)
  end
end
