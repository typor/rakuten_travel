class RakutenApiSettings
  class << self
    def application_id(refresh = true)
      current_keys(refresh)[:application_id]
    end

    def affiliate_id
      current_keys[:affiliate_id]
    end

    def build_keys(arr)
      [].tap do |keys|
        arr.each do |hash|
          next unless hash.key? 'application_id'
          (hash.delete('boost') || 1).to_i.times {
            keys << {application_id: hash['application_id'], affiliate_id: hash['affiliate_id']}
          }
        end
      end
    end

    def api_keys
      @@api_keys ||= build_keys(Settings.rakuten_api_keys)
    rescue
      [{application_id: nil}]
    end

    def current_keys(refresh = false)
      if refresh || !(defined? @@current_keys) || @@current_keys.nil?
        @@current_keys = api_keys.sample
      end
      @@current_keys || {}
    end

    def init
      @@current_keys = nil
      @@api_keys = nil
    end
  end
end