require "it_follows/client/version"

module ItFollows
  module Client
    class Base
      attr_accessor :email, :token

      def initialize(email, token)
        @email = email
        @token = token
      end

      def list(name)
        uri = uri(name)
        response = get(name, uri, email, token)
        JSON.parse(response.body)
      end

      def new(name, payload)
        #ojo porque aca solo esta pensado para un line entry con esa data
        uri = uri(name)
        response = post(name, payload, uri, email, token)
        JSON.parse(response.body)
      end

      def show(name, id)
        uri = uri_for_show(name, id)
        response = get(name, uri, email, token)
        JSON.parse(response.body)
      end

      private
        def host
          'http://localhost:3000'
        end

        def headers(email, token)
          {
            'X-User-Token' => token,
            'X-User-Email' => email,
            'Accept' => 'application/json',
            'Content-Type' => 'application/json'
          }
        end

        def uri(name)
          URI.parse("#{host}/#{name}.json")
        end

        def build_http(name, uri)
          Net::HTTP.new(uri.host, uri.port)
        end

        def get(name, uri, email, token)
          build_http(name, uri).get(uri.path, headers(email, token))
        end

        def post(name, payload, uri, email, token)
          build_http(name, uri).post(uri.path, payload.to_json, headers(email, token))
        end

        def uri_for_show(name, id)
          URI.parse("#{host}/#{name}/#{id}/edit.json")
        end
    end
  end
end
