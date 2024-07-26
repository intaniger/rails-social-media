class PostsController < ApplicationController
  def index
    @posts = Post.all
  end


  def new
    if !user_signed_in?
      redirect_to '/users/sign_in'
    end
    @post = Post.new
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    if !user_signed_in?
      redirect_to '/users/sign_in'
    end
    user_model = User.find(current_user.id)
    begin
      new_post = user_model.post.create!(article_params)
      redirect_to "/posts/#{new_post.id}"
    rescue ActiveRecord::RecordInvalid => e
      logger.info("#{e}")
      render :error, locals: {err_msg: "#{e}"}, status: 422
    end
  end

  private
    def article_params
      params.require(:post).permit(:title, :body)
    end
end
