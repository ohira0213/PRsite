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
  rescue ActiveRecord::RecordNotFound
  #指定されたuser_idが見つからない時は、nilを返す
    @user = nil
    render :new
    if @user
      if @user.valid_password?(params[:user][:password]) && (@user.is_active == false)
        flash[:alert] = "退会済みです。再度ご登録ください。"
        redirect_to new_user_registration_path
      end
    else
      flash.now[:alert] = "該当するユーザーが見つかりません。"
      render :new
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email])
  end
end
