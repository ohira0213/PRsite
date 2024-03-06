class Public::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  def after_sign_up_path_for(resource)
    public_user_path(resource)
  end

  def after_sign_in_path_for(resource)
  # sign_in中の遷移先を指定
    public_posts_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
  end
end
