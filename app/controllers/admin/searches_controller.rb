class Admin::SearchesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @range = params[:range]
    @word = params[:word]
    if @word.blank?
      flash[:alert] = "検索ワードを入力してください。"
      redirect_to request.referer
    elsif @range == "ご利用者様名"
      @users = User.looks(params[:search], @word).where.not(email: "guest@example.com")
    end
  end

  private

  def search
    params.require(:search).permit(:user_id, :post_id,)
  end
end
