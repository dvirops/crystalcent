module Cent
  class Client
    module Api
      # `publish` command allows to publish data into channel. It looks like this:
      #
      # - channel [String] Channel name.
      # - data [(Hash(String, _) | NamedTuple)] data to send in the channel.
      #
      # ```
      # client.publish("channel_x", {text: "value1"})
      # ```
      def publish(channel : String, data : (Hash(String, _) | NamedTuple)) : JSON::Any
        send({"method" => "publish", "params" => {"channel" => channel, "data" => data}})
      end

      # `broadcast` allows to send the same data into many channels.
      #
      # - channels [Array(String)] Channels.
      # - data [(Hash(String, _) | NamedTuple)] data to send in the channel.
      #
      # ```
      # client.broadcast(["channel_x", "channel_y"], {"stam" => "data"})
      # ```
      def broadcast(channels : Array(String), data : (Hash(String, _) | NamedTuple)) : JSON::Any
        send({"method" => "broadcast", "params" => {"channel" => channels, "data" => data}})
      end

      # `unsubscribe` allows to unsubscribe user from channel
      #
      # - channel [String] Channel name.
      # - user [String] User key.
      #
      # ```
      # client.unsubscribe("channel_x", "user_x")
      # ```
      def unsubscribe(channel : String, user : String) : JSON::Any
        send({"method" => "unsubscribe", "params" => {"channel" => channel, "user" => user}})
      end

      # `disconnect` allows to disconnect user by ID
      #
      # - user [String] User key.
      #
      # ```
      # client.disconnect("user_x")
      # ```
      def disconnect(user : String) : JSON::Any
        send({"method" => "disconnect", "params" => {"user" => user}})
      end

      # `presence` allows to get channel presence information (all clients currently subscribed on this channel).
      #
      # - channel [String] Channel name.
      #
      # ```
      # client.presence("channel_x")
      # ```
      def presence(channel : String) : JSON::Any
        send({"method" => "presence", "params" => {"channel" => channel}})
      end

      # `presence_stats` allows to get short channel presence information.
      #
      # - channel [String] Channel name.
      #
      # ```
      # client.presence_stats("channel_x")
      # ```
      def presence_stats(channel : String) : JSON::Any
        send({"method" => "presence_stats", "params" => {"channel" => channel}})
      end

      # `history` allows to get channel history information (list of last messages published into channel).
      #
      # - channel [String] Channel name.
      #
      # ```
      # client.history("channel_x")
      # ```
      def history(channel : String) : JSON::Any
        send({"method" => "history", "params" => {"channel" => channel}})
      end

      # `channels` allows to get list of active (with one or more subscribers) channels.
      #
      # ```
      # client.channels
      # ```
      def channels : JSON::Any
        send({"method" => "channels", "params" => "{}"})
      end

      # `info` method allows to get information about running Centrifugo nodes.
      #
      # ```
      # client.info
      # ```
      def info : JSON::Any
        send({"method" => "info", "params" => "{}"})
      end

      def send(json : Hash(String, _) | NamedTuple)
        post("/api", json: json).parse
      end
    end
  end
end
