# frozen_string_literal: true

# == Schema Information
#
# Table name: wx_menus
#
#  id         :integer          not null, primary key
#  menu_type  :string
#  name       :string
#  key        :string
#  url        :string
#  sequence   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class WxMenu < ActiveRecord::Base
  validates :key, presence: true, if: -> { menu_type == 'click' }
  validates :url, presence: true, if: -> { menu_type == 'view' }

  has_many :wx_sub_menus, dependent: :destroy
  accepts_nested_attributes_for :wx_sub_menus, allow_destroy: true
  default_scope { order('wx_menus.sequence ASC') }

  MENU_TYPES = {
    click: '事件触发',
    view:  '链接跳转'
  }.freeze

  KEYS = {
    contact_us: '联系我们'
  }.freeze

  def human_type
    menu_type.present? ? MENU_TYPES[menu_type.to_sym] : ''
  end

  def human_key
    key.present? ? KEYS[key.to_sym] : ''
  end
end
