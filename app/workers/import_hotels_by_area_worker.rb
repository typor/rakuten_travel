class ImportHotelsByAreaWorker
  include Sidekiq::Worker
  sidekiq_options queue: :import

  def perform(area_id)
    area = Area.find_by(id: area_id)
    if area.nil?
      logger.error "Unknown Area id: #{area_id}"
      return
    end

    api = Api::HotelApi.new(RakutenApiSettings.application_id, RakutenApiSettings.affiliate_id)
    hotels = api.request(area)
    c = 0
    hotels.each do |hotel|
      if hotel.save
        logger.info "Saving #{hotel.no}"
        c += 1
      else
        logger.error "Failed to save [#{area.long_name}]" + hotel.errors.full_messages.join("\n")
      end
    end
    # set all nil
    hotels = api = area = nil
  end
end