require 'telegram/bot'

@telegram_bot_token = '6851187280:AAE2xtSVFBuGOnjaEyELh3KFdlDazYgnFBA'
Thread.new do
  Telegram::Bot::Client.run(@telegram_bot_token) do |bot|
    bot.listen do |message|
      case message
      when Telegram::Bot::Types::Message
        chat_id = message.chat.id
        case message.text
        when '/start'
          chatid_user = Subscriber.find_by(chat_id: chat_id)
          if chatid_user.present?
            bot.api.send_message(chat_id: chat_id, text: "Вы уже подписались на бота")
          else
            Subscriber.create(chat_id: chat_id)
            bot.api.send_message(chat_id: chat_id, text: "Добро пожаловать, введите '/help' для просмотра всех команд")
          end
        when '/help'
          bot.api.send_message(chat_id: chat_id, text: "Вот весь список команд:\n/start - подписать на нашего бота\n/stop - отписка от бота\n/login - привязка вашего телеграма к аккаунту на сайте\n/categories - подписаться на отдельные категории\n/uncategories - отписаться от категории")
        when '/stop'
          chatid_user = Subscriber.find_by(chat_id: chat_id)
          if chatid_user.present?
            bot.api.send_message(chat_id: chat_id, text: "Вы отписались от оповещений.")
            Subscriber.find_by(chat_id: chat_id)&.destroy
          else
            bot.api.send_message(chat_id: chat_id, text: "Вы еще не подписаны на бота")
          end
        when '/login'
          bot.api.send_message(chat_id: chat_id, text: "Пожалуйста перейдите по ссылке для привязки: http://localhost:3000/model1/sign_in?chat_id=#{chat_id}")
        when '/categories'
          subscriber = Subscriber.find_by(chat_id: chat_id)
          if subscriber.present?
            @categories = Category.all - subscriber.categories
            inline_keyboard = @categories.map do |category|
              Telegram::Bot::Types::InlineKeyboardButton.new(
                text: category.name,
                callback_data: "subscribe_#{category.id}"
              )
            end
            markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: inline_keyboard.each_slice(2).to_a)
            bot.api.send_message(chat_id: chat_id, text: 'Выберите категории, на которые хотите подписаться:', reply_markup: markup)
          else
            bot.api.send_message(chat_id: chat_id, text: 'Вы еще не подписались на бота. Отправьте команду /start для начала работы.')
          end
        when '/uncategories'
          subscriber = Subscriber.find_by(chat_id: chat_id)
          if subscriber.present?
            categories = subscriber.categories
            if categories.present?
              inline_keyboard = categories.map do |category|
                Telegram::Bot::Types::InlineKeyboardButton.new(
                  text: category.name,
                  callback_data: "unsubscribe_#{category.id}"
                )
              end
              markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: inline_keyboard.each_slice(2).to_a)
              bot.api.send_message(chat_id: chat_id, text: 'Выберите категории, от которых хотите отписаться:', reply_markup: markup)
            else
              bot.api.send_message(chat_id: chat_id, text: 'Вы не подписаны ни на одну категорию.')
            end
          else
            bot.api.send_message(chat_id: chat_id, text: 'Вы еще не подписались на бота. Отправьте команду /start для начала работы.')
          end
        end
      
      when Telegram::Bot::Types::CallbackQuery
        callback_data = message.data
        if callback_data.start_with?('subscribe_')
          category_id = callback_data.split('_').last.to_i
          category = Category.find(category_id)
          subscriber = Subscriber.find_by(chat_id: message.message.chat.id)
          subscriber.categories << category
          bot.api.send_message(chat_id: message.message.chat.id, text: "Вы подписались на категорию #{category.name}")
        elsif callback_data.start_with?('unsubscribe_')
          category_id = callback_data.split('_').last.to_i
          category = Category.find(category_id)
          subscriber = Subscriber.find_by(chat_id: message.message.chat.id)
          subscriber.categories.delete(category)
          bot.api.send_message(chat_id: message.message.chat.id, text: "Вы отписались от категории #{category.name}")
        end
      end
    end
  end
end