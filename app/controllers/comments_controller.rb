class CommentsController < ApplicationController
    before_action :authenticate_user!

    def destroy
        @post = Post.find(params[:post_id])
        @comment = @post.comments.find(params[:id])
        if model1_signed_in? && (current_model1 == @comment.model1)
            @comment.destroy
            redirect_to post_path(@post)
        else
            redirect_to posts_path, alert: 'Вы не можете удалить этот комментарий'
        end
    end

    def edit
        @post = Post.find(params[:post_id])
        @comment = @post.comments.find(params[:id])
        if model1_signed_in? && (current_model1 == @comment.model1)
        else
            redirect_to posts_path, alert: 'Вы не можете изменить чужой комментарий'
        end
    end

    def update
        @post = Post.find(params[:post_id])
        @comment = @post.comments.find(params[:id])
        if model1_signed_in? && (current_model1 == @comment.model1)
            if @comment.update(comment_params)
                redirect_to post_path(@post), notice: 'Комментарий успешно обновлен.'
             else
                render :edit
            end
        else
            redirect_to posts_path, alert: 'Вы не можете изменить чужой комментарий'
        end
    end

    def create
        @post = Post.find(params[:post_id])
        @user123=@post.model1
        @chat_id=@user123.chatid
        @comment = current_model1.comments.build(comment_params)
        @comment.post_id=@post.id
        @user=current_model1.email
        if (@comment.save)
            if @chat_id.present?
                @message="На ваш пост: '#{@post.title}' пришел новый комментарий: #{@comment.body}.\nАвтор: #{@comment.username} \nСсылка: #{post_url(@post)}"
                redirect_to controller: 'bots', action: 'comments', message: @message, chat_id: @chat_id, post: @post
            else
                redirect_to post_path(@post)
            end
        end
    end

    private def comment_params
        params.require(:comment).permit(:username, :body)
    end

    def authenticate_user!
        redirect_to new_model1_session_path, alert:"Зарегистрируйтесь чтобы получить доступ ко всем функциям" unless model1_signed_in?
    end

end
