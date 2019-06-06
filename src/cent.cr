require "./cent/**"

module Cent
  # Alias for Cent::Client.new
  def self.client(endpoint : String, api_key : String) : Client
    Client.new(endpoint, api_key)
  end
end
