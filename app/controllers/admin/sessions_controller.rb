class Admin::SessionsController < Devise::SessionsController
  def after_sign_in_path_for(resource)
    admin_root_path
  end

  def destroy
    sign_out(resource)
    flash[:notice] = "ログアウトしました。"
    redirect_to admin_session_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email])
  end
end
