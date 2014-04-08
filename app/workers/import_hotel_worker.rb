class ImportHotelWorker
  include Sidekiq::Worker
  sidekiq_options queue: :import

  def perform(area_id)
    area = Area.find(area_id)
    api = Api::HotelApi.new(Settings.application_id, Settings.affiliate_id)
    api.request(area).each_with_index do |hotel, i|
      if hotel.save
        puts "[#{i+1}] Saving ... " + hotel.no.to_s + ' ' + hotel.long_name
      end
    end

  end
end