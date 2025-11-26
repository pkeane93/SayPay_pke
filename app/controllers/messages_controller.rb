class MessagesController < ApplicationController

  def create
    @chat = Chat.find(params[:chat_id])

    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    if @message.save
      llm_response = RubyLLM.chat.ask("Reply to the following message: #{@message.content}")
      @llm_reply = Message.create!(chat: @chat, content: llm_response.content, role: "assistant")
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
