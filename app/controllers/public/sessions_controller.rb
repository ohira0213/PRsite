class Public::SessionsController < Devise::SessionsController

  def after_sign_in_path_for(resource)
    public_posts_path
  end

  def create
     @user = User.find_by_email(params[:user][:email])
    if !@user
       flash[:alert] = "ログインに失敗しました。"
       render :new
    elsif @user&.valid_password?(params[:user][:password]) && @user.is_active
      sign_in(@user)
      redirect_to public_posts_path, notice: "ログインしました。"
    elsif  !@user.is_active
       flash[:alert] = "すでに退会済みです。"
      render :new
    else
      flash[:alert] = "ログインに失敗しました。"
      render :new
    end
  end

  def destroy
    sign_out(resource)
    redirect_to user_session_path, notice: "ログアウトしました。"
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email])
  end
end
