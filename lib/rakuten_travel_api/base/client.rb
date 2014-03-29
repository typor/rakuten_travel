require 'digest/md5'

module RakutenTravelApi
  module Base
    class Client
      API_END_POINT = "https://app.rakuten.co.jp/".freeze
      attr_reader :response

      def initialize(request_url, application_id = nil, affiliate_id = nil)
        init_params(application_id, affiliate_id)
        @request_url = request_url
        yield @params if block_given?
      end

      def request
        raise 'Not implement'
      end

      def init_params(application_id, affiliate_id)
        raise "not implement"
      end

      def connection
        @connection ||= new_connection
      end

      def params
        @params.to_hash
      end

      def parameter_digest
        Digest::MD5.hexdigest(@params.to_hash.values.to_s)
      end

      def add_param(name, value)
        @params[name] = value
      end

      def add_params(params)
        @params.add_params params
      end

      protected

      def get_request
        connection.get(@request_url, params)
      end

      def connection
        @connection ||= new_connection
      end

      def new_connection
        ::Faraday.new(url: ::RakutenTravelApi::Base::Client::API_END_POINT) do |faraday|
          faraday.request  :url_encoded
          faraday.adapter  Faraday.default_adapter
        end
      end
    end
  end
end