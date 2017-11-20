class ReservationExamination < OdooRecord
  self.table_name = 'fa_reservation_examination'

  include Wisper.model

  belongs_to :reservation
  belongs_to :examination
  has_many :reservation_examination_images
  accepts_nested_attributes_for :reservation_examination_images
end
