class VacantWorker
  include Sidekiq::Worker
  sidekiq_options queue: :import

  def perform(hotel_id, checkin, count = 7)
    hotel = Hotel.find(hotel_id)
    logger.info "Target hotel: " + hotel.no + " " + hotel.long_name
    api = Api::VacantApi.new(hotel, Settings.application_id, Settings.affiliate_id)
    sleep_time = Settings.api_sleep_time rescue 0.8
    count.to_i.times do |i|
      response = api.request(checkin.to_i + i)
      logger.info "importing: " + response.size.to_s
      logger.info "client: " + api.api_client.response.to_s
      sleep sleep_time
    end
  end
end