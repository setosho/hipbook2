class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  def new
     @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user.id)
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path, notice: "ユーザー情報を変更しました"
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to new_user_path, notice: "ユーザーを削除しました"
  end

  def favorite_picture
    @user = User.find(params[:id])
    @favorites = current_user.favorites
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :profile,
                                 :password_confirmation, :image, :image_cache)
  end

  def ensure_correct_user
    if current_user.id != params[:id].to_i
      redirect_to new_session_path
    end
  end
end
