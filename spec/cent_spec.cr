require "./spec_helper"

describe Cent do
  context ".client" do
    it "should be a Cent::Client" do
      Cent.client("string", "api_key").should be_a Cent::Client
    end

    it "should not override each other" do
      client1 = Cent.client("https://cent1.example.com", "api_key")
      client2 = Cent.client("https://cent2.example.com", "api_key")
      client1.endpoint.should eq "https://cent1.example.com"
      client2.endpoint.should eq "https://cent2.example.com"
    end

    it "should set username and password when provided" do
      client = Cent.client("https://cent2.example.com", "api_key")
      client.endpoint.should eq "https://cent2.example.com"
      client.api_key.should eq "api_key"
    end
  end
end
