class Public::UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    #user_idが見つからない時は、nilを返す
  rescue ActiveRecord::RecordNotFound
    @user = nil
    flash[:notice] = "指定されたユーザーが見つかりません"
    redirect_to public_posts_path
  end

  def edit
    @user = User.find(params[:id])
    #指定されたuser_idがログイン中のuser_idと異なった場合は開けない
    if @user != current_user
    flash[:notice] = "アクセスできません"
    redirect_to public_posts_path
  end
    #指定されたuser_idが見つからない時は、nilを返す
  rescue ActiveRecord::RecordNotFound
    @user = nil
    flash[:notice] = "アクセスできません"
    redirect_to public_posts_path
  end

  def update
  @user = User.find(params[:id])
  if @user.update(user_params)
    flash[:notice] = "プロフィールを変更しました"
    redirect_to public_user_path(@user.id)
  else
    flash[:notice] = "プロフィールの変更に失敗しました"
    redirect_to edit_public_user_path
  end
end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :is_active, :profile_image)
  end
end
