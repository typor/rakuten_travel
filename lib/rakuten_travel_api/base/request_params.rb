module RakutenTravelApi
  module Base
    class RequestParams
      BASE_VALID_NAMES = %w(applicationId affiliateId elements)
      attr_accessor :invalid_params_action
      attr_reader :errors

      # Initialize
      # @param [String] application_id Rakuten Web Service applicationId
      #    If application_id is nil, application_id set to RakutenApi.config.application_id
      # @param [String] affiliate_id Rakuten Web Service affiliateId
      #    If affiliate_id is nil, affiliate_id set to RakutenApi.config.affiliate_id
      # @param [Symbol] invalid_params_action :raise or :stdout or :none
      #    If invalid_params_action is nil, invalid_params_action set to RakutenApi.config.invalid_params_action
      def initialize(application_id = nil, affiliate_id = nil, invalid_params_action = nil)
        @invalid_params_action = invalid_params_action || :raise
        @params = {}
        @errors = {}
        add_params application_id: application_id, affiliate_id: affiliate_id
      end

      def add_param(name, value)
        _name = normalize(name)
        raise ArgumentError.new('invalid parameter name: ' + name.to_s) unless valid_name?(_name)
        @params[_name] = value
      rescue => e
        if @invalid_params_action == :raise
          raise e
        elseif @invalid_params_action == :stdout
          puts e.message
        end
      end

      def add_params(params)
        raise ArgumentError.new('params is not Hash') unless params.kind_of?(Hash)
        params.each_pair do |k, v|
          add_param(k, v)
        end
      end

      def inspect
        @params
      end

      def has?(name)
        @params.key?(normalize(name))
      end

      def [](name)
        _name = normalize(name)
        @params[_name]
      end

      def []=(name, value)
        add_param(name, value)
      end

      def to_hash
        @params ||= {}
        @params.reject!{|k,v| v.nil? }
        @params
      end

      def valid?
        validate
        @errors.size == 0
      end

      def validate
        clear_error
        if @params['applicationId'].blank?
          add_error('applicationId', 'applicationId is required.')
        end
      end

      def valid_name?(name)
        valid_names.include? name
      end

      def normalize(name)
        name = name.to_s
        name = name.split('_').tap{|names| break names.shift + names.map(&:capitalize).join } if name =~ /.+\_.+/
        name
      end

      def valid_names
        BASE_VALID_NAMES
      end

      def add_error(key, message)
        name = normalize(key)
        return unless valid_name?(name)
        @errors[name] ||= []
        @errors[name] << message
      end

      def clear_error()
        @errors = {}
      end
    end
  end
end