# frozen_string_literal: true

# Wisper.subscribe(ReservationSubscriber.new)
# Wisper.subscribe(UserSubscriber.new)
# Wisper.subscribe(DoctorSubscriber.new)
# Wisper.subscribe(ImagingExaminationImageSubscriber.new)
# Wisper.subscribe(MedicalRecordImageSubscriber.new)
# Wisper.subscribe(LaboratoryExaminationImageSubscriber.new)

# https://github.com/krisleech/wisper/issues/119#issuecomment-130572197
# https://stackoverflow.com/questions/28346609/reload-wisper-listeners-automatically-at-every-request/28362286#28362286
Rails.application.config.to_prepare do
  Wisper.clear if Rails.env.development? || Rails.env.test?
  #   Wisper.subscribe(ReservationSubscriber.new)
  Wisper.subscribe(Auditor.new)

  filenames = Dir.entries('app/subscribers/').reject { |f| File.directory? f }.map { |f| f.gsub!('.rb', '') }
  classes = filenames.map { |f| f.classify.constantize }

  classes.each do |subscriber|
    # Wisper.subscribe(subscriber.new)
    # publisher = subscriber.name.gsub("Subscriber", "").classify.constantize
    Wisper.subscribe(subscriber, async: true)
  end
end

# Log publish events
Wisper.configure do |config|
  config.broadcaster :default, Wisper::Broadcasters::LoggerBroadcaster.new(Rails.logger, Wisper::Broadcasters::SendBroadcaster.new)
  # config.broadcaster :async,   LoggerBroadcaster.new(Rails.logger, SidekiqBroadcaster.new) # if using async
end
