class Public::SessionsController < Devise::SessionsController

  def after_sign_in_path_for(resource)
    public_root_path
  end

  def destroy
    sign_out(resource)
    redirect_to user_session_path, notice: "ログアウトしました。"
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:name, :email, :password])
  end
end
