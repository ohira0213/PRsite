class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!

  def top
    @requests = Request.page(params[:page]).per(5).includes(:user)
  end
end
