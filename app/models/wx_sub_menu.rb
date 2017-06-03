# frozen_string_literal: true

# == Schema Information
#
# Table name: wx_sub_menus
#
#  id         :integer          not null, primary key
#  wx_menu_id :integer
#  menu_type  :string
#  name       :string
#  key        :string
#  url        :string
#  sequence   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class WxSubMenu < ActiveRecord::Base
  belongs_to :wx_menu

  default_scope { order('wx_sub_menus.sequence ASC') }

  def human_type
    menu_type.present? ? WxMenu::MENU_TYPES[menu_type.to_sym] : ''
  end

  def human_key
    key.present? ? WxMenu::KEYS[key.to_sym] : ''
  end
end
