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
end
