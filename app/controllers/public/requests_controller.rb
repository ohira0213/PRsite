class Public::RequestsController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find(params[:user_id])
    if user
      request = current_user.build_request(user_id: user.id)
      #新しいRequestオブジェクトを作成
      request.save
      flash[:notice] = "認証マークを申請しました。"
      redirect_to edit_public_user_path(user)
    end
  end

  def request_params
    params.require(:request).permit(:user_id, :mark_status, :mark)
  end
end
