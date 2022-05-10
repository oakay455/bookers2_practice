class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    @newbook = Book.new
  end

  def index
    @book = Book.new
    @books = Book.all
  end

  def create
    @book = Book.new(book_params) #フォームに入力されたデータ(book_paramsで許可されたもの)が@bookに格納されるよう準備。空のモデル。
    @book.user_id = current_user.id
    #モデル名.カラム名とすると保存するカラムの中身を操作できる。この記述は、投稿した人のid(user_id)をcurrent_userと定義している。
    #投稿データ(@book)のuser_idを、current_user.id(今ログインしているユーザーの ID)に指定することで、投稿データに、今ログイン中のユーザーの ID を持たせることができる。
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      @user = current_user
      render :index
    end
  end

  def edit
    @book = Book.find(params[:id])
    if @book.user_id = current_user.id
      render :edit
    else
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end
end
