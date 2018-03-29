# frozen_string_literal: true

class BankAccount < OdooRecord
  self.table_name = 'fa_bank_account'

  belongs_to :user
  # belongs_to :contract, required: false
end
