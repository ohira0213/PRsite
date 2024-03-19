class Public::SessionsController < Devise::SessionsController
  before_action :reject_public, only: [:create]

  def after_sign_in_path_for(resource)
    public_posts_path
  end

  def destroy
    sign_out(resource)
    flash[:notice] = "ログアウトしました。"
    redirect_to user_session_path
  end

  def guest_sign_in
    user = User.guest
    sign_in user
    flash[:notice] = "ゲストユーザーでログインしました。"
    redirect_to public_user_path(user)
  end

  protected

  def reject_public
    @user = User.find_by(email: params[:user][:email])
    #@userがnilでないことを確認する
    if @user && @user.valid_password?(params[:user][:password]) && !@user.is_active?
    #nilでないことを確認する
      if @user.valid_password?(params[:user][:password]) && (@user.is_active == false)
      #パスワードが`params[:user][:password]`と一致するか確認し、is_activeがfalseであるか確認する
        flash[:alert] = "退会済みです。再度ご登録ください。"
        redirect_to new_user_registration_path
      else
        flash.now[:alert] = "メールアドレスまたはパスワードが違います。"
        render :new
      end
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email])
  end
end
