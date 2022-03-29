class PostsController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    tag_list = params[:post][:tag].split("#")
    @post.attach_tags(tag_list)
    if @post.save
      redirect_to post_path(@post.id)
    else
      render "new"
    end
  end

  def index
    # "RAND()"は本番環境用の記述。開発時は"RANDOM()"にする
    @posts = Post.all.order("RAND()").page(params[:page]).per(16)
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
    @tags = @post.tags.pluck(:name).join('#')
  end

  def update
    @post = Post.find(params[:id])
    tag_list = params[:post][:tag].split("#")
    if tag_list.length == 0
      @post.errors.add(:🏷, "タグを入力してください")
      render "edit"
    else
      @post.fix_tags(tag_list)
      if @post.update(post_params)
        @post.destroy_tag
        redirect_to post_path(@post)
      else
        render "edit"
      end
    end
  end

  def destroy
    post = Post.find(params[:id])
    user = post.user
    post.destroy_tag
    post.destroy
    redirect_to user_path(user)
  end

  # タグでの検索
  def search_tag
    @tags = Tag.all
    @tag = Tag.find(params[:tag_id])
    @posts = @tag.posts.page(params[:page]).per(16)
    render "index"
  end

  # 普通の検索
  def search
    @posts = Post.search(params[:word]).page(params[:page]).per(16)
    @word = params[:word]
    @tags = Tag.all
    render "index"
  end

  #新着順
  def sort_time
    @posts = Post.all.order(created_at: :desc).page(params[:page]).per(16)
    @tags = Tag.all
    render "index"
  end
  
  #いいねランキング
  def rank_favorite
    @rank = Post.find(Favorite.group(:post_id).order('count(post_id) desc').limit(16).pluck(:post_id))
    @posts = Kaminari.paginate_array(@rank).page(params[:page]).per(16)
    @tags = Tag.all
    render "index"
  end

  #コメント数ランキング
  def rank_comment
    @rank = Post.find(Comment.group(:post_id).order('count(post_id) desc').limit(16).pluck(:post_id))
    @posts = Kaminari.paginate_array(@rank).page(params[:page]).per(16)
    @tags = Tag.all
    render "index"
  end

  #ブックマークランキング
  def rank_bookmark
    @rank = Post.find(Bookmark.group(:post_id).order('count(post_id) desc').limit(16).pluck(:post_id))
    @posts = Kaminari.paginate_array(@rank).page(params[:page]).per(16)
    @tags = Tag.all
    render "index"
  end

  #PV数ランキング
  def rank_view
    @rank = Post.find(Impression.group(:impressionable_id).order('count(impressionable_id) desc').limit(16).pluck(:impressionable_id))
    @posts = Kaminari.paginate_array(@rank).page(params[:page]).per(16)
    @tags = Tag.all
    render "index"
  end

  private

  def post_params
    params.require(:post).permit(:title, :thumbnail, :video, :content)
  end

  def ensure_correct_user
    @post = Post.find(params[:id])
    unless @post.user == current_user
      redirect_to posts_path
    end
  end

end
