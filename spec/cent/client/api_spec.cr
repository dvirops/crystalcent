require "../../spec_helper"

describe Cent::Client::Api do
  describe "#info" do
    it "should return status information" do
      stub_post("/api", "info")
      info = client.info
      info.should be_a JSON::Any
      info["result"].is_a? Hash
      info["result"]["nodes"].is_a? Array
      (info["result"]["nodes"][0]["num_channels"].as_i >= 0).should eq true
      (info["result"]["nodes"][0]["num_clients"].as_i >= 0).should eq true
      (info["result"]["nodes"][0]["num_users"].as_i >= 0).should eq true
      (info["result"]["nodes"][0]["uptime"].as_i >= 0).should eq true
    end
  end

  describe "#channels" do
    it "get list of active (with one or more subscribers) channels" do
      stub_post("/api", "channels")
      channels = client.channels

      channels.should be_a JSON::Any
      channels["result"]["channels"].is_a? Array
      channels["result"]["channels"][0].should eq "chat"
      (channels["result"]["channels"].size >= 0).should eq true
    end
  end

  describe "#history" do
    it "get channel history information (list of last messages published into channel)" do
      stub_post("/api", "history")
      history = client.history("channel_x")

      history.should be_a JSON::Any
      history["result"]["publications"].is_a? Array
      history["result"]["publications"][0]["uid"].should eq "BWcn14OTBrqUhTXyjNg0fg"
      history["result"]["publications"][1]["uid"].should eq "Ascn14OTBrq14OXyjNg0hg"
    end
  end

  describe "#presence_stats" do
    it "get short channel presence information" do
      stub_post("/api", "presence_stats")
      presence_stats = client.presence_stats("channel_x")

      presence_stats.should be_a JSON::Any
      presence_stats["result"].is_a? Hash
      (presence_stats["result"]["num_clients"].as_i >= 0).should eq true
      (presence_stats["result"]["num_users"].as_i >= 0).should eq true
    end
  end

  describe "#presence" do
    it "get full channel presence information" do
      stub_post("/api", "presence")
      presence = client.presence("channel_x")

      presence.should be_a JSON::Any
      presence["result"]["presence"].is_a? Hash
      (presence["result"]["presence"].size >= 0).should eq true
    end
  end

  describe "#disconnect" do
    it "disconnect user by ID" do
      stub_post("/api", "disconnect")
      disconnect = client.disconnect("user_x")

      disconnect.should be_a JSON::Any
    end
  end

  describe "#unsubscribe" do
    it "unsubscribe user from channel" do
      stub_post("/api", "unsubscribe")
      unsubscribe = client.unsubscribe("channel_x", "user_x")

      unsubscribe.should be_a JSON::Any
    end
  end

  describe "#broadcast" do
    it "send the same data into many channels" do
      stub_post("/api", "broadcast")
      broadcast = client.broadcast(["channel_x", "channel_y"], {"stam" => "data"})

      broadcast.should be_a JSON::Any
    end
  end

  describe "#publish" do
    it "publish data into channel" do
      stub_post("/api", "publish")
      publish = client.publish("channel_x", {"stam" => "data"})

      publish.should be_a JSON::Any
    end
  end
end
