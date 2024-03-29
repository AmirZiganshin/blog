class CategoriesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  def index
    @categories = Category.all
  end

  def show
    @categories=Category.find(params[:id])
    @post = @categories.posts
  end

  def new
    if model1_signed_in? && (current_model1.admin? || current_model1.moderator?)
      @category = Category.new
    else
      redirect_to categories_path, alert: 'У вас нет прав для добавления категории'
    end
  end
  
  def edit
    if model1_signed_in? && (current_model1.admin? || current_model1.moderator?)
      @categories=Category.find(params[:id])
    else
      redirect_to categories_path, alert: 'У вас нет прав для изменения категории'
    end
  end

  def create
    @category = Category.new(category_params)
      if @category.save
        @message = "Новая категория создана: #{@category.name}"
        redirect_to controller: 'bots', action: 'clientadmin', message: @message, category: @category
      else
        render 'edit'
      end
  end

  def update
    @categories = Category.find(params[:id])
      if @categories.update(category_params)
        redirect_to @categories
      else
        render 'edit'
      end
  end

  def category_params
    params.require(:category).permit(:name)
  end

  def authenticate_user!
    redirect_to new_model1_session_path, alert:"Зарегистрируйтесь чтобы получить доступ ко всем функциям" unless model1_signed_in?
  end
end
