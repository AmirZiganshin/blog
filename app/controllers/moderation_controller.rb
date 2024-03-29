class ModerationController < ApplicationController

    def moderate
        if model1_signed_in? && ( current_model1.admin? || current_model1.moderator?)
            @post = Post.where(moderated: false).paginate(page: params[:page], per_page: 2)
            @post=@post.all.order(created_at: :desc)
        else
            redirect_to posts_path, alert: 'Вы не можете перейти по этой ссылке'
        end
    end

    def show
        if model1_signed_in? && ( current_model1.admin? || current_model1.moderator?)
            @post=Post.find(params[:id])
        else
            redirect_to posts_path, alert: 'Вы не можете перейти по этой ссылке'
        end
    end

    def confirm
        @post=Post.find(params[:id])
        @message = "Новый пост создан: #{@post.title}\nКатегория: #{@post.category.name}\n"
        @user=@post.model1.email
        @post.update(moderated: 1, moderated_at: Time.now)
        @user1=@post.model1
        @chat_id=@user1.chatid
        @postitle=@post.title
        @category = @post.category
        subscriber = @category.subscribers.pluck(:chat_id)
        @message2="В категории '#{@category.name}' вышел новый пост!\nНазвание: #{@post.title}\nАвтор: #{@post.model1.email}"
        redirect_to controller: 'bots', action: 'clientadmin', message: @message, post: @post, user: @user, chat_id: @chat_id, postitle: @postitle, subscriber: subscriber, message2: @message2
    end

    def destroy
        @post=Post.find(params[:id])
        @user1=@post.model1
        @chat_id=@user1.chatid
        @post.destroy
        if @chat_id.present?
            @message="Ваш пост '#{@post.title}' был отклонен и удален, так как он нарушает правила нашего сайта"
            redirect_to controller: 'bots', action: 'destroy', user: @user, chat_id: @chat_id, message: @message
        else
            redirect_to moderate_path, alert: "Пост ты успешно отклонен"
        end
    end

end
