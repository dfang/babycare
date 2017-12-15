# frozen_string_literal: true

class ReservationExaminationImage < OdooRecord
  self.table_name = 'fa_reservation_examination_image'

  include Wisper.model

  belongs_to :reservation_examination
end
