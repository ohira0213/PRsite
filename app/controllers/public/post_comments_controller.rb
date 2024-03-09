class Public::PostCommentsController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    comment = post.post_comments.new(post_comment_params)
    comment.user_id = current_user.id

    if comment.save
      flash[:notice] = "コメントを投稿しました。"
      redirect_to public_post_path(post.id)
    else
      error_messages = []
      error_messages << "コメントを入力してください。" if post_comment_params[:comment].blank?
      error_messages << "コメントは100文字以内で入力してください。" if post_comment_params[:comment].to_s.length > 100
      flash[:alert] = "コメントが投稿できませんでした。" + error_messages.join(" ") unless error_messages.empty?
      redirect_to request.referer
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
