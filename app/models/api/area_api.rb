class Api::AreaApi
  def initialize(application_id)
    @client = RakutenTravelApi::GetAreaClass::Client.new(application_id)
  end

  def request
    response ||= @client.request
    unless response.success?
      Rails.logger.error "[#{@client.id}] Response error" + @response.body.to_s
      return []
    end

    response.areas.map do |f|
      build_area(f)
    end
  end

  def build_area(params)
    attributes = {}
    params.each_pair do |k, v|
      if valid_keys.key? k
        attributes[valid_keys[k]] = v
      elsif k != 'largeClassName'
        attributes[:long_name] = attributes.key?(:long_name) ? attributes[:long_name] + '/' + v : v
      end
    end

    keys = attributes.select{|k, v| valid_keys.values.include?(k) && v.present? }
    (Area.find_by(keys) || Area.new).tap do |o|
      o.attributes = attributes
    end
  end

  def valid_keys
    @@valid_keys ||= {
      'largeClassCode' => :large,
      'middleClassCode' => :middle,
      'smallClassCode' => :small,
      'detailClassCode' => :detail,
    }.freeze
  end
end