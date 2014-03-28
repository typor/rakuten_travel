namespace :api do
  desc "Call GetAreaClass api and import area data into database"
  task get_area_class: :environment do
    Api::AreaApi.new(Settings.application_id).request.each_with_index do |area, i|
      if area.save
        puts "Adding ... " + area.long_name
      else
        puts "Skipping ... " + area.long_name
      end
    end
  end

  task import_hotels: :environment do
    Area.where(enabled: true).each do |area|
      Api::HotelApi.new(Settings.application_id, Settings.affiliate_id).request(area).each_with_index do |hotel, i|
        if hotel.save
          puts "[#{i+1}] Saving ... " + hotel.no.to_s + ' ' + hotel.name
        else
          puts "[#{i+1}] Skipping ... " + hotel.no.to_s + ' ' + hotel.name
        end
      end
    end
  end
end
