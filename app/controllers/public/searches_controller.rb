class Public::SearchesController < ApplicationController
  def search
    @range = params[:range]
    @word = params[:word]

    if @word.blank?
      flash[:alert] = "検索ワードを入力してください。"
      redirect_to request.referer
    elsif @range == "ユーザー名"
      @users = User.looks(params[:search], @word).where.not(email: "guest@example.com").where(is_active: true)
      render :index
    elsif @range == "PR文"
      @posts = Post.looks(params[:search], @word).where("text LIKE ?", "%#{@word}%").joins(:user).where(users: { is_active: true })
      render :index
    end
  end
end
