# frozen_string_literal: true

class ReservationImage < OdooRecord
  # establish_connection("odoo_#{Rails.env}".to_sym)
  self.table_name = 'fa_reservation_image'

  include Wisper.model

  belongs_to :reservation
end
