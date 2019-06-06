require "../spec_helper"

describe Cent::Client do
  describe ".initialize" do
    it "should initialize client" do
      Cent::Client.new(CENT_ENDPOINT, CENT_API_KEY).should be_a Cent::Client
    end
  end

  describe ".available?" do
    it "should return true if service works" do
      stub_get("/health", "health")
      client.available?.should be_true
    end
  end
end
