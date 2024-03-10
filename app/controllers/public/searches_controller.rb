class Public::SearchesController < ApplicationController
  def search
    @range = params[:range]
    @word = params[:word]

    if @word.blank?
      flash[:alert] = "検索ワードを入力してください。"
      redirect_to request.referer
    elsif @range == "User"
      @users = User.looks(params[:search], @word)
      render :index
    elsif @range == "Post"
      @posts = Post.looks(params[:search], @word).where("text LIKE ?", "%#{@word}%")
      render :index
    end
  end
end
