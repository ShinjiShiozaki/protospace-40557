class PrototypesController < ApplicationController
  #★
  before_action :set_prototype, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :contributor_confirmation, only: [:edit, :update, :destroy]

  def index
    #★
    #@prototypes = Prototype.all
    @prototypes = Prototype.includes(:user)
  end

  def new
    @prototype = Prototype.new
  end

  def show
    #binding.pry
    #showアクションにインスタンス変数@prototypeを定義
    #且つ、Pathパラメータで送信されるID値で、Prototypeモデルの特定のオブジェクトを取得するように記述
    #それを@prototypeに代入
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments
  end

  def create
    @prototype = Prototype.create(prototype_params)
    #saveメソッドは悪さをしないのか
    if  @prototype.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
      #render :new
    end
  end

  def edit
    unless user_signed_in?
      redirect_to action: :index
    end
    
    #editアクションにインスタンス変数@prototypeを定義
    #且つ、Pathパラメータで送信されるID値で、Prototypeモデルの特定のオブジェクトを取得するように記述
    #それを@prototypeに代入した
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @prototype = Prototype.find(params[:id])
    #binding.pry
    if @prototype.destroy
      redirect_to root_path
    else
      redirect_to root_path
    end
  end

  private

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end

  def contributor_confirmation
    redirect_to root_path unless current_user == @prototype.user
  end


end
