class PostsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show, :search_tag, :search]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    tag_list = params[:post][:tag].split(",")
    if @post.save
      @post.save_tag(tag_list)
      redirect_to post_path(@post.id)
    else
      render "new"
    end
  end


  def index
    @posts = Post.all
    @tags = Tag.all
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @tags = @post.tags
    impressionist(@post, nil, unique: [:ip_address])
  end

  def edit
    @post = Post.find(params[:id])
    @tags = @post.tags.pluck(:name).join(',')
  end

  def update
    @post = Post.find(params[:id])
    tag_list = params[:post][:tag].split(",")
    if @post.update(post_params)
      @post.save_tag(tag_list)
      tags = Tag.all
      tags.each do |tag|
        if tag.posts.count == 0
          tag.destroy
        end
      end
      redirect_to post_path(@post)
    else
      render "edit"
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    tags = Tag.all
    tags.each do |tag|
      if tag.posts.count == 0
        tag.destroy
      end
    end
    redirect_to posts_path
  end

  # タグでの検索
  def search_tag
    @tags = Tag.all
    @tag = Tag.find(params[:tag_id])
    @posts = @tag.posts
    render "index"
  end

  # 普通の検索
  def search
    @posts = Post.search(params[:word])
    @word = params[:word]
    @tags = Tag.all
    render "index"
  end

  private

  def post_params
    params.require(:post).permit(:title, :thumbnail, :video, :content)
  end
end
