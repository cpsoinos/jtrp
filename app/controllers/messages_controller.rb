class MessagesController < ApplicationController

  def create
    @message = Message.new(message_params)
    if @message.save
      flash[:notice] = "Thanks! We'll get back to you shortly."
      redirect_to root_path
    else
      flash[:warning] = "Uh-oh. We couldn't send your message, but we've been notified of an error."
      redirect_to root_path
    end
  end

  protected

  def message_params
    params.require(:message).permit(:name, :email, :phone, :message)
  end

end
