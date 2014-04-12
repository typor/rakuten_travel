class ImportHotelsByAreaWorker
  include Sidekiq::Worker
  sidekiq_options queue: :import

  def perform(area_id)
    logger.info "Starting"

    area = Area.find_by(id: area_id)
    if area.nil?
      logger.error "Unknown Area id: #{area_id}"
      return
    end

    api = Api::HotelApi.new(Settings.application_id, Settings.affiliate_id)
    hotels = api.request(area)
    c = 0
    hotels.each do |hotel|
      if area.save
        logger.info "Saving #{hotel.no}"
        c += 1
      else
        logger.error "Failed to save [#{area.long_name}]" + area.errors.full_messages.join("\n")
      end
    end
    logger.info "Finished"
    # set all nil
    hotels = api = area nil
  end
end