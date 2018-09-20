class CBNotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "cb_notifications"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end
end
