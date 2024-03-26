class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.page(params[:page]).per(5)
  end

  def edit
    @user = User.find(params[:id])
    if guest_user?(@user)
      flash[:alert] = "ゲストユーザーは編集できません。"
      redirect_to admin_users_path
    elsif @user.nil?
    #ユーザーが見つからなかった場合に@userはnilとなる
      flash[:alert] = "該当ユーザーは存在しません。"
      redirect_to admin_users_path
    end
  rescue ActiveRecord::RecordNotFound
  #エラーが発生した場合にリダイレクトする
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

  def guest_user?(user)
    user.email == "guest@example.com"
  end

  def user_params
    params.require(:user).permit(:name, :introduction, :email, :password, :is_active, :profile_image)
  end
end
