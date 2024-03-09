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
      error_messages = []
       # エラーメッセージを格納するための配列を初期化
      error_messages << "タイトルを入力してください。" if @post.errors[:title].present?
      # タイトルに関するエラーが存在する場合
      error_messages << "PR文を入力してください。" if @post.errors[:text].present?
      # PR文に関するエラーが存在する場合
      flash[:alert] = "投稿ができませんでした。" + error_messages.join(" ")
      # エラーメッセージを結合してフラッシュメッセージとして設定
      redirect_to request.referer
    end
  end

  def index
    @posts = Post.all
    @post_comment = PostComment.new
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
  rescue ActiveRecord::RecordNotFound
  #指定されたuser_idまたはpost_idが見つからない時は、nilを返す
    @post = nil
    @user = nil
    flash[:alert] = "指定された投稿が見つかりません。"
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
