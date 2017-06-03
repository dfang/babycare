# frozen_string_literal: true

module ImageVersion
  extend ActiveSupport::Concern

  module ClassMethods
    def mount_image_version(column)
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{column}_url(version = nil)
          @#{column}_generator = Images::Generator.new self, :#{column}
          @#{column}_generator.url(version)
        end
      RUBY
    end
  end
end
