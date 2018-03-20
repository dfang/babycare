# frozen_string_literal: true

class OdooRecord < ActiveRecord::Base
  # evaluate ENV first, good for production deployment
  # http://edgeguides.rubyonrails.org/configuring.html#configuring-a-database
  establish_connection(ENV['ODOO_DATABASE_URL'] || "odoo_#{Rails.env}".to_sym)

  self.abstract_class = true

  def gid
    to_global_id
  end
end
