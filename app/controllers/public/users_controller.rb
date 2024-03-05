class Public::UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    #user_idが見つからない時は、nilを返す
  rescue ActiveRecord::RecordNotFound
    @user = nil
  end

  def edit
    @user = User.find(params[:id])
    #user_idが見つからない時は、nilを返す
  rescue ActiveRecord::RecordNotFound
    @user = nil
  end

  def update
  @user = User.find(params[:id])
  if @user.update(user_params)
    redirect_to public_user_path(@user.id), notice: "プロフィールを変更しました"
  else
    redirect_to edit_public_user, alert: "プロフィールの変更に失敗しました"
  end
end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :is_active, :profile_image)
  end
end
