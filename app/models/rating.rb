class Rating < ActiveRecord::Base
  establish_connection("odoo_#{Rails.env}".to_sym)
  self.table_name = 'fa_rating'

  belongs_to :user
  belongs_to :reservation

  acts_as_taggable
end
