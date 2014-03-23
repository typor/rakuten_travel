module RakutenTravelApi
  module Base
    class Params
      BASE_VALID_NAMES = %w(applicationId affiliateId).freeze
      attr_accessor :invalid_params_action

      # Initialize
      # @param [String] application_id Rakuten Web Service applicationId
      #    If application_id is nil, application_id set to RakutenApi.config.application_id
      # @param [String] affiliate_id Rakuten Web Service affiliateId
      #    If affiliate_id is nil, affiliate_id set to RakutenApi.config.affiliate_id
      # @param [Symbol] invalid_params_action :raise or :stdout or :none
      #    If invalid_params_action is nil, invalid_params_action set to RakutenApi.config.invalid_params_action
      def initialize(application_id = nil, affiliate_id = nil, invalid_params_action = nil)
        init_params application_id, affiliate_id
        @invalid_params_action = invalid_params_action || :raise
      end

      def init_params(application_id, affiliate_id)
        @params = {}
        add_param('applicationId', application_id)
        add_param('affiliateId', affiliate_id)
      end

      def add_param(name, value)
        _name = normalize(name)
        if valid_name?(_name)
          @params[_name] = value
        else
          if @invalid_params_action == :raise
            raise 'passed invalid param: ' + name.to_s
          elsif @invalid_params_action == :stdout
            puts "Warning: " + name.to_s + ' is invalid name'
          end
        end
      end

      def add_params(params)
        raise 'Need hash' unless params.kind_of?(Hash)
        params.each_pair do |k, v|
          add_param(k, v)
        end
      end

      def inspect
        @params
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
    end
  end
end