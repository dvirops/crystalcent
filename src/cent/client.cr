require "./client/**"
require "halite"
require "json"
require "base64"

module Cent
  # Centrifugo API Client wrapper
  #
  # See the [Centrifugo API](https://centrifugal.github.io/centrifugo/server/http_api/) for more details.
  class Client
    # The endpoint of Centrifugo
    property endpoint

    # The API Key (for authentication) of Centrifugo
    property api_key

    # :nodoc:
    enum ErrorType
      JsonError
      NonJsonError
    end

    # Create a new client
    #
    # ```
    # Cent::Client.new("<endpoint>", "<api_key>")
    # ```
    def initialize(@endpoint : String, @api_key : String)
    end

    {% for verb in %w(get head) %}
      # Return a Halite::Response by sending a {{verb.id.upcase}} method http request
      #
      # ```
      # client.{{ verb.id }}("/path", params: {
      #   first_name: "foo",
      #   last_name:  "bar"
      # })
      # ```
      def {{ verb.id }}(uri : String, headers : (Hash(String, _) | NamedTuple)? = nil, params : (Hash(String, _) | NamedTuple)? = nil) : Halite::Response
        headers = headers ? default_headers.merge(headers) : default_headers
        response = Halite.{{verb.id}}(build_url(uri), headers: headers, params: params)
        validate(response)
        response
      end
    {% end %}

    {% for verb in %w(post put patch delete) %}
      # Return a `Halite::Response` by sending a {{verb.id.upcase}} http request
      #
      # ```
      # client.{{ verb.id }}("/path", form: {
      #   first_name: "foo",
      #   last_name:  "bar"
      # })
      # ```
      def {{ verb.id }}(uri : String, headers : (Hash(String, _) | NamedTuple)? = nil, params : (Hash(String, _) | NamedTuple)? = nil, form : (Hash(String, _) | NamedTuple)? = nil, json : (Hash(String, _) | NamedTuple)? = nil) : Halite::Response
        headers = headers ? default_headers.merge(headers) : default_headers
        response = Halite.{{verb.id}}(build_url(uri), headers: headers, params: params, form: form, json: json)
        validate(response)
        response
      end
    {% end %}

    # Return a `Bool` status by Centrifugo service
    #
    # - Return `Bool`
    #
    # ```
    # client.available? # => true
    # ```
    def available?
      get("/health")
      true
    rescue
      false
    end

    # Validate http response status code and content type
    #
    # Raise an exception if status code >= 400
    #
    # - **400**: `Error::BadRequest`
    # - **401**: `Error::Unauthorized`
    # - **403**: `Error::Forbidden`
    # - **404**: `Error::NotFound`
    # - **405**: `Error::MethodNotAllowed`
    # - **409**: `Error::Conflict`
    # - **422**: `Error::Unprocessable`
    # - **500**: `Error::InternalServerError`
    # - **502**: `Error::BadGateway`
    # - **503**: `Error::ServiceUnavailable`
    private def validate(response : Halite::Response)
      case response.status_code
      when 400 then raise Error::BadRequest.new(response)
      when 401 then raise Error::Unauthorized.new(response)
      when 403 then raise Error::Forbidden.new(response)
      when 404 then raise Error::NotFound.new(response)
      when 405 then raise Error::MethodNotAllowed.new(response)
      when 409 then raise Error::Conflict.new(response)
      when 422 then raise Error::Unprocessable.new(response)
      when 500 then raise Error::InternalServerError.new(response)
      when 502 then raise Error::BadGateway.new(response)
      when 503 then raise Error::ServiceUnavailable.new(response)
      when 507 then raise Error::InsufficientStorage.new(response)
      end
    end

    # Set a default Auth(Basic Authentication) header
    private def default_headers : Hash(String, String)
      Hash(String, String).new.tap do |obj|
        if @api_key != nil
          obj["Authorization"] = "apikey " + (@api_key.to_s).chomp
        end

        obj["Accept"] = "application/json"
        obj["User-Agent"] = "Centrifugo.cr v#{VERSION}"
      end
    end

    # Return a full url string from built with base domain and url path
    private def build_url(uri)
      File.join(@endpoint, uri)
    end

    include Api
  end
end
