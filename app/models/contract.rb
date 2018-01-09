class Contract < OdooRecord
  self.table_name = 'fa_contract'
  belongs_to :user
  # has_one :bank_account

  # accepts_nested_attributes_for :bank_account
end
