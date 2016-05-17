class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_category 

  # GET /posts
  # GET /posts.json
  def index
    @post = @category.posts
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post =@category.posts.new
  end

  # GET /posts/1/edit
  def edit
    tag_titles = @post.tags.map {|tag| tag.title}
    @post.tag_titles = tag_titles.join(',')
  
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = current_user.posts.new(post_params)
    @post.category = @category
    tags = get_tags(post_params[:tag_titles], ',')
    tags.each do |tag|
      @post.tags << tag
    end
    respond_to do |format|
      if @post.save
        format.html { redirect_to @category, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    return head(:forbidden) unless @post.user == current_user
    respond_to do |format|
      if @post.update(post_id)
        format.html { redirect_to @category, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        return head(:forbidden) unless @post.user == current_user
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    return head(:forbidden) unless @post.user == current_user
    # @post.destroy
    respond_to do |format|
      if @post.destroy(post_params)
        format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { render :edit }
        return head(:forbidden) unless @post.user == current_user
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def get_tags(str, delim)
      titles = str.split(delim)
      tags = []
      titles.each do |title|
          title.strip!
          next unless title && title.length
          tags << Tag.where(title: title).first_or_create
        end
        return tags
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :body, :username, :tag_titles)
    end
    
    def set_category
      @category = Category.find(params[:category_id])
    end
end
