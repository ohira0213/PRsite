class Public::PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :index, :show, :destroy]
  before_action :ensure_guest_user, only: [:new]

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
      error_messages << "商品紹介文を入力してください。" if @post.errors[:text].present?
      # PR文に関するエラーが存在する場合
      flash[:alert] = "投稿ができませんでした。" + error_messages.join(" ")
      # エラーメッセージを結合してフラッシュメッセージとして設定
      redirect_to request.referer
    end
  end

  def index
    @posts = Post.joins(:user).where("users.is_active <> ? ",false)
    @post_comment = PostComment.new
  end

  def show
    @post = Post.find(params[:id])
    if @post.user.is_active == false
      flash[:alert] = "指定された投稿が見つかりません。"
      redirect_to public_posts_path
    end
    @post_comment = PostComment.new
    @post.post_comments = PostComment.joins(:user).where("users.is_active <> ? ",false)
    @post.favorites = Favorite.joins(:user).where("users.is_active <> ? ",false)
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

  def ensure_guest_user
    if current_user.email == "guest@example.com"
      flash[:alert] = "ゲストユーザーは一部閲覧のみ可能です。"
      redirect_to public_posts_path
    end
  end

  def post_params
    params.require(:post).permit(:user_id, :text, :post_image)
  end
end
