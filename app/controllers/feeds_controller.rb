class FeedsController < ApplicationController
  before_action :set_feed, only: [:show, :edit, :update, :destroy, :authenticate_user]
  before_action :authenticate_user, only: [:edit, :update, :destroy]

  # GET /feeds
  # GET /feeds.json
  def index
    @feeds = Feed.all
  end

  # GET /feeds/1
  # GET /feeds/1.json
  def show
    @favorite = current_user.favorites.find_by(feed_id: @feed.id)
  end

  # GET /feeds/new
  def new
    @feed = Feed.new
    if params[:back]
      @feed = Feed.new(feed_params)
    else
      @feed = Feed.new
    end
  end

  def confirm
    @feed = Feed.new(feed_params)
    @feed.user_id = current_user.id
    render :new if @feed.invalid?
  end

  # GET /feeds/1/edit
  def edit
  end

  # POST /feeds
  # POST /feeds.json
  def create
    @feed = Feed.new(feed_params)
    @feed.user_id = current_user.id

    respond_to do |format|
      if @feed.save
        FeedMailer.feed_mail(@feed).deliver if Rails.env.development?
        format.html { redirect_to @feed, notice: '画像の投稿に成功しました' }
        format.json { render :show, status: :created, location: @feed }
      else
        format.html { render :new }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /feeds/1
  # PATCH/PUT /feeds/1.json
  def update
    respond_to do |format|
      if @feed.update(feed_params)
        format.html { redirect_to @feed, notice: '更新しました' }
        format.json { render :show, status: :ok, location: @feed }
      else
        format.html { render :edit }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feeds/1
  # DELETE /feeds/1.json
  def destroy
    @feed.destroy
    respond_to do |format|
      format.html { redirect_to feeds_url, notice: '削除しました' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_feed
    @feed = Feed.find(params[:id])
  end

    # Never trust parameters from the scary internet, only allow the white list through.
  def feed_params
    params.require(:feed).permit(:image, :image_cache, :content)
  end

  def authenticate_user
    if current_user != @feed.user
      flash[:notice] = "あなたの投稿では無いので操作できません"
      redirect_to feeds_path
    end
  end
end
