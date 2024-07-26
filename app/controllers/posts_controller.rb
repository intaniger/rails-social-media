class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  # [View] Create new post
  def new
    if !user_signed_in?
      redirect_to '/users/sign_in'
    end
    @post = Post.new
  end

  # [view] Post modification  
  def edit
    begin
      @post = Post.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render :error, locals: {err_msg: "Post not found"}, status: 404
    end
  end

  # Update existing post
  def update
    @post = Post.find(params[:id])
    if(@post.user.id != current_user.id)
      render :error, locals: {err_msg: "Forbidden"}, status: 403
    elsif @post.update(article_params)
      redirect_to @post
    else
      render :error, locals: {err_msg: @post.errors.full_messages}, status: 422
    end
  end

  # Get post by id
  def show
    begin
      @post = Post.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render :error, locals: {err_msg: "Post not found"}, status: 404
    end
    
  end

  # Destroy post
  def destroy
    @post = Post.find(params[:id])
    if(@post.user.id != current_user.id)
      render :error, locals: {err_msg: "Forbidden"}, status: 403
      return
    else 
      @post.destroy
    end
 
    redirect_to posts_path
  end

  # Create new post
  def create
    if !user_signed_in?
      redirect_to '/users/sign_in'
    end
    user_model = User.find(current_user.id)
    begin
      new_post = user_model.post.create!(article_params)
      redirect_to "/posts/#{new_post.id}"
    rescue ActiveRecord::RecordInvalid => e
      logger.error("#{e}")
      render :error, locals: {err_msg: "#{e}"}, status: 422
    end
  end

  private
    def article_params
      params.require(:post).permit(:title, :body)
    end
end
