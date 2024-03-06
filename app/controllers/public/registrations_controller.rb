class Public::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  def after_sign_up_path_for(resource)
    public_user_path(@user)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
  end
end
