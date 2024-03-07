class Public::FavoritesController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    if post
      favorite = current_user.favorites.new(post_id: post.id)
      favorite.save
      redirect_to request.referer
    else
      flash[:notice] = "指定された投稿が見つかりません"
      redirect_to public_posts_path
    end
  end

  def destroy
    post = Post.find(params[:post_id])
    if post
      favorite = current_user.favorites.find_by(post_id: post.id)
      favorite.destroy
      redirect_to request.referer
    else
      flash[:notice] = "指定された投稿が見つかりません"
      redirect_to public_posts_path
    end
  end
end
