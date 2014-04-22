class VacantWorker
  include Sidekiq::Worker
  sidekiq_options queue: :import

  def perform(hotel_id, checkin, count = 7)
    hotel = Hotel.find(hotel_id)
    logger.info "Target hotel: " + hotel.no + " " + hotel.long_name
    api = Api::VacantApi.new(hotel, Settings.application_id, Settings.affiliate_id)
    count.to_i.times do |i|
      response = api.request(checkin.to_i + i)
      logger.info "importing: " + response.size.to_s
      logger.info "client: " + api.api_client.response.to_s
      sleep 2
    end
  end
end