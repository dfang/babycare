class ReservationExamination < OdooRecord
  self.table_name = 'fa_reservation_examination'

  belongs_to :reservation
  belongs_to :examination
end
