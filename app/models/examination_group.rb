# frozen_string_literal: true

class ExaminationGroup < OdooRecord
  self.table_name = 'fa_examination_group'

  has_many :examinations, dependent: :destroy
end
