class Public::PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :index, :show, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to public_posts_path, notice: "投稿しました"
    else
      redirect_to new_public_post, alert: "投稿に失敗しました"
    end
  end

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  #user_idまたはpost_idが見つからない時は、nilを返す
  rescue ActiveRecord::RecordNotFound
    @post = nil
    @user = nil
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to public_posts_path, notice: "削除しました"
  end

  private

  def post_params
    params.require(:post).permit(:user_id, :title, :text, :post_image)
  end
end
