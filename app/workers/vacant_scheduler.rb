class VacantScheduler
  include Sidekiq::Worker
  sidekiq_options queue: :scheduler

  def perform(checkin, count)
    checkin = checkin.to_i rescue nil
    count = count.to_i rescue nil
    raise ArgumentError.new 'checkin gte 0 & count get 1' if checkin < 0 || count <= 0
    Hotel.where(enabled: true).ids.each do |id|
      VacantWorker.perform_async(id, checkin, count)
    end
  end
end