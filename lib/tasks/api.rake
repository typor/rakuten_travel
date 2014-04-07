namespace :api do
  desc "楽天のエリア検索APIを呼び出し、地区情報をDBに登録します。"
  task import_areas: :environment do
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
    api = Api::HotelApi.new(Settings.application_id, Settings.affiliate_id)
    if ENV['AREA_ID'].nil?
      Area.where(enabled: true).each do |area|
        puts "Area: " + area.long_name
        api.request(area).each_with_index do |hotel, i|
          if hotel.save
            puts "[#{i+1}] Saving ... " + hotel.no.to_s + ' ' + hotel.long_name
          end
        end
      end
    else
      area = Area.find_by(id: ENV['AREA_ID'])
      if area
        api.request(area).each_with_index do |hotel, i|
          if hotel.save
            puts "[#{i+1}] Saving ... " + hotel.no.to_s + ' ' + hotel.long_name
          end
        end
      end
    end
  end

  desc "ホテルNoを元に最新の予約可能な施設情報を取得します。 HOTEL_NO=*** CHECKIN=*** COUNT=***"
  task research_by_hotel_no: :environment do
    if ENV['HOTEL_NO'].blank?
      puts "ENV['HOTEL_NO']を指定してください。"
      return
    end

    hotel = Hotel.find_by(no: ENV['HOTEL_NO'])
    checkin = ENV['CHECKIN']
    checkin = 1 if checkin.to_i <= 0
    count = ENV['COUNT']
    count = 1 if count.to_i <= 0

    count.to_i.times do |i|
      charges = Api::VacantApi.new(hotel, Settings.application_id, Settings.affiliate_id).request(checkin.to_i + i)
      if charges.size == 0
        puts "指定されたCHECKINの日付における予約可能な部屋は存在しません。"
      end

      charges.each_with_index do |charge, i|
        puts "[#{i+1}] Adding ... " + charge.plan.long_name + '...' + charge.room.name + '...' + charge.amount.to_s
      end
    end
  end

  desc "有効になっているホテルの部屋情報を取得します。"
  task import_charges: :environment do
    checkin = ENV['CHECKIN']
    checkin = 1 if checkin.to_i <= 0
    count = ENV['COUNT']
    count = 1 if count.to_i <= 0
    sleep_time = Settings.api_sleep_time || 0.8
    Hotel.where(enabled: true).each do |hotel|
      puts "Importing ... " + hotel.no + " " + hotel.long_name
      api = Api::VacantApi.new(hotel, Settings.application_id, Settings.affiliate_id)
      count.to_i.times do |i|
        api.request(checkin.to_i + i)
        sleep sleep_time
      end
    end
  end
end
