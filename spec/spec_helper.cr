require "spec"
require "webmock"
require "../src/cent"

CENT_ENDPOINT = "https://centrifugo.example.com"
CENT_API_KEY  = "key"

Spec.before_each &->WebMock.reset

def client
  Cent.client(CENT_ENDPOINT, CENT_API_KEY)
end

def load_fixture(name : String?)
  return "" unless name
  File.read_lines(File.dirname(__FILE__) + "/fixtures/#{name}.json").join("\n")
end

# GET
def stub_get(path, fixture = nil, params = nil, response_headers = {} of String => String, status = 200)
  query = "?#{HTTP::Params.encode(params)}" if params

  response_headers.merge!({"Content-Type" => "application/json"})
  WebMock.stub(:get, "#{client.endpoint}#{path}#{query}")
    .with(headers: {"Authorization" => "apikey " + (client.api_key.to_s).chomp})
    .to_return(status: status, body: load_fixture(fixture), headers: response_headers)
end

# POST
def stub_post(path, fixture = nil, status_code = 200, params = nil, json = nil, response_headers = {} of String => String)
  query = "?#{HTTP::Params.escape(params)}" if params
  body = json.to_json if json

  response_headers.merge!({"Content-Type" => "application/json"})
  WebMock.stub(:post, "#{client.endpoint}#{path}#{query}")
    .with(body: body, headers: {"Authorization" => "apikey " + (client.api_key.to_s).chomp})
    .to_return(body: load_fixture(fixture), headers: response_headers, status: status_code)
end
