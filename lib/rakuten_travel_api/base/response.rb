require 'json'

module RakutenTravelApi
  module Base
    class Response
      attr_reader :status
      attr_reader :body

      def initialize(faraday_response = nil)
        if !faraday_response.nil? && !faraday_response.kind_of?(::Faraday::Response)
          raise 'not specified Faraday::Response'
        end
        @status = faraday_response.nil? ? nil : faraday_response.status
        @body = json_parse(faraday_response.nil? ? '' : faraday_response.body)
      end

      def success?
        @status == 200
      end

      def error?
        !success?
      end

      def error_message
        nil if success?
        message = ''
        message += @body['error'] + ': ' if @body.include? 'error'
        message += @body['error_description'] if @body.include? 'error_description'
        message == '' ? 'no error message' : message;
      end

      protected

      def json_parse(data)
        ::JSON.parse(data)
      rescue ::JSON::ParserError => e
        {}
      end
    end
  end
end