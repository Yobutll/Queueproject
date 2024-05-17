class QueueManagmentChannel < ApplicationCable::Channel

  def subscribed
    stream_from "queue_managment_channel"
  end

  def unsubscribed
    
  end


  
end
