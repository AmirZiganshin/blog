class PostsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show, :search]

    def index
        @post = Post.where(moderated: true).paginate(page: params[:page], per_page: 2)
        @post=@post.all.order(moderated_at: :desc)
    end 

    
    def search
        @post = Post.where("title LIKE ? AND moderated = ?", "%#{params[:query]}%", 1)
    end

    def new
        @post = current_model1.posts.build
        @categories=Category.all.order(:name)
    end

    def show
        @post=Post.find(params[:id])
    end
    
    def edit
        @post=Post.find(params[:id])
        if model1_signed_in? && current_model1 == @post.model1
            @categories=Category.all.order(:name)
        else
            redirect_to posts_path, alert: 'Вы не можете изменить этот пост'
        end
    end

    def user
        @user = Model1.find( params[:model1_id] )
        @posts = Post.where( model1: @user ).order( created_at: :desc )
    end

    def update
        @post = Post.find(params[:id])
        if model1_signed_in? && current_model1 == @post.model1
            @categories = Category.all
            if current_model1.admin? || current_model1.moderator?
                if(@post.update(post_params))
                    redirect_to @post
                else
                    @categories = Category.all
                    render 'edit', categories: @categories
                end
            else
                @post.moderated=0
                @check=1
                if(@post.update(post_params))
                    @message="Промодерировать новый пост: #{@post.title}"
                    @user=@post.model1.email
                    redirect_to controller: 'bots', action: 'clientuser', message: @message, post: @post, user: @user
                else
                    @categories = Category.all
                    render 'edit', categories: @categories
                end
            end
        else
            redirect_to posts_path, alert: 'Вы не можете изменить этот пост'
        end
    end

    def destroy
        @post=Post.find(params[:id])
        if model1_signed_in? && current_model1 == @post.model1
            @post.destroy
            redirect_to posts_path
        elsif current_model1.admin? || current_model1.moderator?
            @user1=@post.model1
            @chat_id=@user1.chatid
            @post.destroy
            if @chat_id.present?
                @check=1
                @message="Ваш пост '#{@post.title}' был удален администрацией, так как он нарушает правила нашего сайта"
                redirect_to controller: 'bots', action: 'destroy', user: @user, chat_id: @chat_id, message: @message, check: @check
            else    
                redirect_to posts_path, alert: 'Пост был успешно удален'
            end
        else
            redirect_to posts_path, alert: 'Вы не можете изменить этот пост'
        end
    end

    def create
        @post = current_model1.posts.build(post_params)
        if current_model1.admin? || current_model1.moderator?
            @post.moderated=1
            @post.moderated_at=Time.now
        else
            @post.moderated=0
        end
        if(@post.save)
            if current_model1.admin? || current_model1.moderator?
                @category = @post.category
                subscriber = @category.subscribers.pluck(:chat_id)
                @message2="В категории '#{@category.name}' вышел новый пост!\nНазвание: #{@post.title}\nАвтор: #{@post.model1.email}"
                @message = "Новый пост создан: #{@post.title}\nКатегория: #{@post.category.name}\n"
                @user=@post.model1.email
                redirect_to controller: 'bots', action: 'clientadmin', message: @message, post: @post, user: @user, subscriber: subscriber, message2: @message2
            else
                @message="Промодерировать новый пост: #{@post.title}"
                @user=@post.model1.email
                redirect_to controller: 'bots', action: 'clientuser', message: @message, post: @post, user: @user
            end
       else
            @categories=Category.all.order(:name)
            render 'new', categories: @categories
       end
    end

    private def post_params
        params.require(:post).permit(:title, :body, :category_id)
    end


    def authenticate_user!
        redirect_to new_model1_session_path, alert:"Зарегистрируйтесь чтобы получить доступ ко всем функциям" unless model1_signed_in?
      end
end
