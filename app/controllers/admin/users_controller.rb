class Admin::UsersController < ApplicationController
  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
  #指定されたuser_idが見つからない時は、nilを返す
    @user = nil
    flash[:alert] = "該当ユーザーは存在しません。"
    redirect_to admin_users_path
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      if @user.previous_changes.include?(:is_active)
        flash[:notice] = "ご利用状況を変更しました。"
        redirect_to admin_users_path
      else
        flash.now[:alert] = "ご利用状況が変更されませんでした。"
        render :edit
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :email, :password, :is_active, :profile_image)
  end
end
