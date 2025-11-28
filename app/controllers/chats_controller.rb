class ChatsController < ApplicationController

  def create
    if current_user.chats.count == 1
      redirect_to chat_path(current_user.chats.first)
    else
      @chat = Chat.create(user: current_user, title: Chat::DEFAULT_TITLE)
      redirect_to chat_path(@chat)
    end
  end

  def show
    @chat = Chat.find(params[:id])
    @message = Message.new
    @messages = Message.all
  end

end
