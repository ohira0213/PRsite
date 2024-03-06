class Public::FavoritesController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    if post
      favorite = current_user.favorites.new(post_id: post.id)
      favorite.save
      if request.referer == public_post_url(post)
      #実行したページが詳細ページだったら詳細ページにリダイレクト
        redirect_to public_post_path(post)
      else
        redirect_to public_posts_path
      end
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
      if request.referer == public_post_url(post)
      #実行したページが詳細ページだったら詳細ページにリダイレクト
        redirect_to public_post_path(post)
      else
        redirect_to public_posts_path
      end
    else
      flash[:notice] = "指定された投稿が見つかりません"
      redirect_to public_posts_path
    end
  end
end
