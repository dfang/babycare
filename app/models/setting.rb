# frozen_string_literal: true

class Setting
  include ActiveModel::Model

  BLOOD_TYPES = %w[A B O AB].freeze
end
