# frozen_string_literal: true

class Examination < OdooRecord
  self.table_name = 'fa_examination'

  belongs_to :examination_group

  has_many :reservation_examinations
end
