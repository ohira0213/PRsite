class Public::FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    if @post
      favorite = current_user.favorites.new(post_id: @post.id)
      favorite.save
      #redirect_to request.referer
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    if @post
      favorite = current_user.favorites.find_by(post_id: @post.id)
      favorite.destroy
      #redirect_to request.referer
    end
  end

  private

  def favorite_params
    params.require(:favorite).permit(:user_id, :post_id,)
  end
end
