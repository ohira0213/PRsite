class Public::PostsController < ApplicationController
  before_action :authenticate_user!
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
      if post_params[:text].blank?
        flash[:alert] = "PR文を入力してください。"
        redirect_to request.referer
      end
      if post_params[:text].to_s.length > 100
        flash[:alert] = "PR文は100文字以内で入力してください。"
        redirect_to request.referer
      end
    end
  end

  def index
    @posts = Post.joins(:user).where("users.is_active <> ? ",false).order(created_at: :desc)
    #users.is_active`がfalseでないユーザーを作成日降順に表示する
    @post_comment = PostComment.new
  end

  def show
    @post = Post.find(params[:id])
    if !@post.user.is_active?
      flash[:alert] = "指定された投稿が見つかりません。"
      redirect_to public_posts_path
    end
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

  def ensure_guest_user
    if current_user.email == "guest@example.com"
      flash[:alert] = "ゲストユーザーは一部閲覧のみ可能です。"
      redirect_to request.referer
    end
  end

  def guest_user?(user)
    user.email == "guest@example.com"
  end

  def post_params
    params.require(:post).permit(:user_id, :text, :post_image)
  end
end
