class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def new 
    @post = Post.new
  end

  def create
    @post = Post.new(article_params)

    if @post.save
      redirect_to @post
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def article_params
      params.require(:post).permit(:title, :body)
    end
end
