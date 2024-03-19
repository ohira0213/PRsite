class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!

  def top
    @requests = Request.joins(:user).where(users: { is_active: true }).page(params[:page]).per(5).includes(:user)
  end
end
