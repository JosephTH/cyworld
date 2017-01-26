class CrawlingController < ApplicationController
  def cyclub
  end

  def telegram
    require 'telegram/bot'

    token = '288439817:AAFe-ue26ei-WM_2TlMlCfeSkqLE4zvKNKQ'
    Telegram::Bot::Client.run(token) do |bot|
      bot.listen do |message|
        case message.text
        when '/start'
          bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
        when '/stop'
          bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
        end
      end
    end
  end
end
