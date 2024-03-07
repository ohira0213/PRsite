class Public::PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :index, :show, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:notice] = "投稿しました。"
      redirect_to public_posts_path
    else
      flash[:error] = "投稿に失敗しました。"
      redirect_to new_public_post_path
    end
  end

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound
  #指定されたuser_idまたはpost_idが見つからない時は、nilを返す
    @post = nil
    @user = nil
    flash[:error] = "指定された投稿が見つかりません。"
    redirect_to public_posts_path
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "投稿を削除しました。"
    redirect_to public_posts_path
  end

  private

  def post_params
    params.require(:post).permit(:user_id, :title, :text, :post_image)
  end
end
