class PostsController < ApplicationController
  def index
    @user = User.find_by(id: params['user_id'])
    @posts = @user.posts.includes(:comments)
  end

  def show
    @post = Post.find_by(id: params['id'], author_id: params['user_id'])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.create(
      author_id: current_user.id,
      title: params['post']['title'],
      text: params['post']['text']
    )

    redirect_to user_post_path(current_user, @post)
  end

  def destroy
    load_and_authorize_resource

    @post = Post.includes(:comments).find_by(id: params['id'], author_id: params['user_id'])

    @post.comments.each(&:destroy)
    @post.likes.each(&:destroy)

    @post.destroy

    @post.user.update_posts_counter

    redirect_to user_posts_path(params['user_id'])
  end

  private

  def post_params
    params.require(:post).permit(:title, :text)
  end
end
