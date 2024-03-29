class BotsController < ApplicationController
    
    def create
        head :ok
    end
    def clientadmin
        subscriber = params[:subscriber]
        message = params[:message]
        message2 = params[:message2]
        post = params[:post]
        category = params[:category]
        user= params[:user]
        check=params[:check]
        chat_id123=params[:chat_id]
        postitle=params[:postitle]
        @telegram_bot_token = '6851187280:AAE2xtSVFBuGOnjaEyELh3KFdlDazYgnFBA'
        Telegram::Bot::Client.run(@telegram_bot_token) do |bot|
        chat_ids = Subscriber.left_outer_joins(:categories).where(categories: { id: nil }).pluck(:chat_id)
        chat_ids.each do |chat_id|
            if category.present?
                bot.api.send_message(chat_id: chat_id, text: "#{message}")
            elsif chat_id.to_s!=chat_id123.to_s
                bot.api.send_message(chat_id: chat_id, text: "#{message}Автор: #{user}\nСсылка: #{post_url(post)}")
            end
        end
        if subscriber.present?
            subscriber.each do |subscriber1|
                bot.api.send_message(chat_id: subscriber1, text: "#{message2}")
            end
        end
        if chat_id123.present?
            bot.api.send_message(chat_id: chat_id123, text: "Ваш пост '#{postitle}' прошел модерацию и был опубликован\nСсылка: #{post_url(post)}")
        end
        if category.present?
            redirect_to category_path(category)
        elsif check.present?
            redirect_to moderate_path, notice: 'Пост успешно обновлен'
        else
            redirect_to post_path(post)
        end
    end
    end

    def clientuser
        message = params[:message]
        post = params[:post]
        user= params[:user]
        @telegram_bot_token = '6851187280:AAE2xtSVFBuGOnjaEyELh3KFdlDazYgnFBA'
        Telegram::Bot::Client.run(@telegram_bot_token) do |bot|
            chat_ids = Model1.where(role: [1, 2]).pluck(:chatid).compact
            chat_ids.each do |chat_id|
                if post.present?
                    bot.api.send_message(chat_id: chat_id, text: "#{message}, Автор: #{user}\nСсылка: #{post_url(post)}")
                end
            end
            redirect_to home_path, alert: "Ваш пост скоро будет промодерирован и добавлен на сайт"
        end
    end

    def comments
        post = params[:post]
        message = params[:message]
        chat_id = params[:chat_id]
        @telegram_bot_token = '6851187280:AAE2xtSVFBuGOnjaEyELh3KFdlDazYgnFBA'
        Telegram::Bot::Client.run(@telegram_bot_token) do |bot|
            bot.api.send_message(chat_id: chat_id, text: "#{message}")
        end
        redirect_to post_path(post)
    end

    def resetchatid
        @user = current_model1
        @user.update(chatid: nil)
        redirect_to edit_model1_registration_path, notice: 'Ваш телеграм успешно сброшен'
    end

    def destroy
        check = params[:check]
        message = params[:message]
        chat_id123=params[:chat_id]
        @telegram_bot_token = '6851187280:AAE2xtSVFBuGOnjaEyELh3KFdlDazYgnFBA'
        Telegram::Bot::Client.run(@telegram_bot_token) do |bot|
            bot.api.send_message(chat_id: chat_id123, text: "#{message}")
        end
        if check.present?
            redirect_to home_path, notice: 'Пост был успешно удален'
        else
            redirect_to moderate_path, notice: 'Пост был успешно отклонен'
        end
    end


    
end
