class QueueManagmentChannel < ApplicationCable::Channel

  def subscribed
    stream_from "QueueManagmentChannel"
  end

  def unsubscribed
    
  end

  def receive(data)
  end
end
