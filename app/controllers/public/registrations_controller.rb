class Public::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  def after_sign_in_path_for(resource)
    public_root_path
  end

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
