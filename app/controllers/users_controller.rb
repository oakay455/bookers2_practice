class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])#必要なユーザー情報を取得
    @books = @user.books #特定のユーザ（@user）に関連付けられた投稿全て（.books）を取得し@booksに渡す
    @book = Book.new
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
    if @user == current_user
      render :edit
    else
    redirect_to user_path(current_user)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
    redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
end
