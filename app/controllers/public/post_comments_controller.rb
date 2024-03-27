class Public::PostCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @post_comment = @post.post_comments.new(post_comment_params)
    @post_comment.user_id = current_user.id
    if @post_comment.save
      flash[:notice] = "コメントを投稿しました。"
      redirect_to public_post_path(@post.id)
    else
      if post_comment_params[:comment].blank?
        flash[:alert] =  "コメントを入力してください。"
        redirect_to request.referer
      end
      if post_comment_params[:comment].to_s.length > 30
        flash[:alert] =  "コメントは30文字以内で入力してください。"
        redirect_to request.referer
      end
    end
  end

  def destroy
    PostComment.find(params[:id]).destroy
    redirect_to public_post_path(params[:post_id])
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:user_id, :post_id, :comment)
  end
end
