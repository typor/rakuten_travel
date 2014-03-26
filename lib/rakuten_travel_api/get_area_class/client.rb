module RakutenTravelApi
  module GetAreaClass
    class Client < ::RakutenTravelApi::Base::Client
      REQUEST_PATH = "/services/api/Travel/GetAreaClass/20131024".freeze
      attr_reader :response

      def initialize(application_id, affiliate_id = nil)
        super(REQUEST_PATH, application_id, affiliate_id)
      end

      def init_params(application_id, affiliate_id)
        @params = ::RakutenTravelApi::GetAreaClass::RequestParams.new(application_id, affiliate_id)
      end

      def request
        yield @params if block_given?
        @response = ::RakutenTravelApi::GetAreaClass::Response.new(get_request)
      end

    end
  end
end