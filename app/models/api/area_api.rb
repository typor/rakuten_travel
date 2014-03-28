class Api::AreaApi
  MAP = {
    "largeClassCode" => :large,
    "middleClassCode" => :middle,
    "smallClassCode" => :small,
    "detailClassCode" => :detail,
  }.freeze

  def initialize(application_id)
    @client = RakutenTravelApi::GetAreaClass::Client.new(application_id)
    @areas = nil
  end

  def request
    return @areas if @areas
    @response ||= @client.request
    unless @response.success?
      raise @response.body.to_s
    end

    @areas = []
    @response.areas.each do |f|
      @areas << to_area(f)
    end
    @areas
  end

  def to_area(params)
    attributes = {}
    params.each_pair do |k, v|
      if MAP.key? k
        attributes[MAP[k]] = v
      elsif k != 'largeClassName'
        attributes[:name] = attributes.key?(:name) ? attributes[:name] + '-' + v : v
      end
    end
    Area.new(attributes)
  end

end