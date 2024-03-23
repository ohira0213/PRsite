class Admin::RequestsController < ApplicationController
  before_action :authenticate_admin!

  def edit
  @user = User.find_by(id: params[:user_id])
  unless @user
    flash[:alert] = "該当ユーザーは存在しません。"
    redirect_to admin_root_path
    return
  end

  @request = Request.find_by(user_id: @user.id, id: params[:id])
  unless @request
    flash[:alert] = "該当リクエストは存在しません。"
    redirect_to admin_root_path
  end
end

  def update
    @request = Request.find(params[:id])
    if @request.update(request_params)
      if @request.previous_changes.include?(:mark_status) && @request.mark_status != 'unverified'
        flash[:notice] = "申請状況を変更しました。"
        redirect_to admin_root_path
      else
        flash[:alert] = "申請状況が変更されませんでした。"
        redirect_to request.referer
      end
    end
  end

  def request_params
    params.require(:request).permit(:user_id, :mark_status, :mark).tap do |whitelisted|
      if params[:request][:mark_status] == 'certifiable'
        whitelisted[:mark] = params[:request][:mark]
      end
      #mark_statusがcertifiableと等しい場合、mark属性をwhitelisted変数に追加する
    end
  end
end
