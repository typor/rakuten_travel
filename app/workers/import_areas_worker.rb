class ImportAreasWorker
  include Sidekiq::Worker
  sidekiq_options queue: :import

  def perform
    logger.info "Starting"
    areas = Api::AreaApi.new(Settings.application_id).request

    c = 0
    areas.each do |area|
      if area.save
        logger.info "Saving #{area.long_name}"
        c += 1
      else
        logger.error "Failed to save [#{area.long_name}]" + area.errors.full_messages.join("\n")
      end
    end
    logger.info "Finished Success: #{c.to_s}, Total: #{areas.size}"
  end
end