namespace :api do
  desc "楽天のエリア検索APIを呼び出し、地区情報をDBに登録します。"
  task get_area_class: :environment do
    Api::AreaApi.new(Settings.application_id).request.each_with_index do |area, i|
      if area.save
        puts "Adding ... " + area.long_name
      else
        puts "Skipping ... " + area.long_name
      end
    end
  end

  desc "施設検索APIを呼び出し、地区情報で有効になっている地区からホテルを検索しDBに登録します。"
  task import_hotels: :environment do
    Area.where(enabled: true).each do |area|
      Api::HotelApi.new(Settings.application_id, Settings.affiliate_id).request(area).each_with_index do |hotel, i|
        if hotel.save
          puts "[#{i+1}] Saving ... " + hotel.no.to_s + ' ' + hotel.long_name
        else
          puts "[#{i+1}] Skipping ... " + hotel.no.to_s + ' ' + hotel.long_name
        end
      end
    end
  end

  desc "ホテルNoを元に最新の施設情報を取得します。"
  task import_rooms: :environment do
    if ENV['HOTEL_NO'].blank?
      puts "ENV['HOTEL_NO']を指定してください。"
      return
    end

    hotel = Hotel.find_by(no: ENV['HOTEL_NO'])

    Api::VacantApi.new(Settings.application_id, Settings.affiliate_id).request(hotel, ENV['START'] || 1).each_with_index do |hotel, i|
      if charge.save
        puts "[#{i+1}] Saving ... " + charge.plan.name + ' ' + charge.room.name + ' ' + charge.price
      else
        puts "[#{i+1}] Skipping"
      end
    end
  end
end
