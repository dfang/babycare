# frozen_string_literal: true

module Images
  class Generator
    # 图片定义在 lib/extras/images/definition
    include Images::Definition
    include Images::VersionHelper

    def initialize(record, column)
      @record = record
      @column = column
    end

    def url(version = '')
      if version.present?
        version = version.to_s

        unless defined_versions.key?(version)
          raise "CoverUploader version: #{version} is not allow."
        end

        if column_value.blank?
          # if column(eg. data) is blank, return a placeholder image
          size   = defined_versions[version]
          width  = size[:width] || 200
          height = size[:height] || 200
          "/holder.js/#{width}x#{height}"
          # nil
        else
          column_value + version_string(version)
        end

      else
        column_value
      end
    end

    private

    def column_value
      @record.send(@column)
    end
  end
end
