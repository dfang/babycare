class ApplicationRecord < ActiveRecord::Base
  establish_connection("odoo_#{Rails.env}".to_sym)

  self.abstract_class = true
end
