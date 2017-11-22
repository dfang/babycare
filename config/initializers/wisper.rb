# frozen_string_literal: true

# Wisper.subscribe(ReservationSubscriber.new)
# Wisper.subscribe(UserSubscriber.new)
# Wisper.subscribe(DoctorSubscriber.new)

# Wisper.subscribe(ImagingExaminationImageSubscriber.new)
# Wisper.subscribe(MedicalRecordImageSubscriber.new)
# Wisper.subscribe(LaboratoryExaminationImageSubscriber.new)

filenames = Dir.entries('app/models/subscribers/').select {|f| !File.directory? f}.map { |f| f.gsub!(".rb", "")}
classes = filenames.map {|f| f.classify.constantize }

classes.each do |c|
  Wisper.subscribe(c.new)
end
