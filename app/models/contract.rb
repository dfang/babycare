class Contract < OdooRecord
  self.table_name = 'fa_contract'
  belongs_to :doctor
  # has_one :bank_account

  # accepts_nested_attributes_for :bank_account
end
