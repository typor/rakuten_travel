class StopReservationWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default

  def perform
    to = 1.days.ago.strftime('%Y%m%d')
    Charge.reservations.where(stay_day: to).each do |o|
      o.can_stay = false
      o.save
      o.add_history
    end
  end
end
